import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/models/market_product_model.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/kid/overlay/hand_pointer_overlay.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/parent_pin_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailDialog extends StatelessWidget {
  final MarketProductModel product;
  final VoidCallback onAddToGoal;

  ProductDetailDialog({
    super.key,
    required this.product,
    required this.onAddToGoal,
  }) {
    _checkTutorialState();
  }
  final RoleController _roleController = Get.find<RoleController>();
  final analytics = Get.find<AnalyticsService>();

  final GlobalKey _addToGoalKey = GlobalKey();
  final RxBool showPointer = true.obs;

  Future<void> _checkTutorialState() async {
    final hasSeenTutorial = SharedPreferencesHelper.getBool(SharedPreferencesHelper.hasSeenAddToGoalTutorial) ?? false;
    showPointer.value = !hasSeenTutorial;
  }

  final appState = Get.find<AppStateController>();
  final Rx<KidModel?> currentKid = Rx<KidModel?>(null);

  void switchToParentMode() {
    final isKidConnected = currentKid.value?.isConnected ?? false;
    if (!isKidConnected) {
      final kidService = Get.find<KidService>();
      kidService.updateKid(
        currentKid.value!.kidId,
        currentKid.value!.copyWith(isConnected: true),
      );
    }

    _roleController.switchToParentMode(true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.backgroundInverse,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Stack(
              children: [
                if (showPointer.value)
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTapDown: (_) async {
                        showPointer.value = false;
                        await SharedPreferencesHelper.saveBool(
                          SharedPreferencesHelper.hasSeenAddToGoalTutorial,
                          true,
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      // Left Column - Image and Add to Goal Button
                      SizedBox(
                        width: 0.25.sw - 20.w, // 25% of dialog width minus padding
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  image: DecorationImage(
                                    image: NetworkImage(product.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            KidButton(
                              key: _addToGoalKey,
                              onTap: () async {
                                await analytics.buttonClicked(
                                    AnalyticsEventNames.marketProductDetailAddToGoalClicked, AnalyticsScreenNames.kidMarketProductDetailScreenDialog,AnalyticsScreenNames.kidMarketScreen);

                                showPointer.value = false;
                                onAddToGoal();
                              },
                              text: 'Add to Goal ',
                              baseColor: AppColors.btnColorOrange,
                              height: 48.w,
                              width: 0.25.sw - 20.w,
                              iconPath: Assets.icGoal,
                              iconPosition: IconPosition.left,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),

                      // Right Column - Title, Description, and Amazon Card
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and Close Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    product.name,
                                    style: AppTextStyle.headingMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                KidButton.iconOnly(
                                  onTap: () async {
                                    Get.back();
                                    await analytics.buttonClicked(
                                        AnalyticsEventNames.marketProductDetailCrossClicked, AnalyticsScreenNames.kidMarketProductDetailScreenDialog);
                                  },
                                  baseColor: AppColors.btnColorOrange,
                                  iconPath: Assets.icCross,
                                  size: 30.w,
                                  iconSize: 15,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),

                            // About Text
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: product.about
                                      .map((about) => Padding(
                                            padding: EdgeInsets.only(bottom: 8.h),
                                            child: Text(
                                              about,
                                              style: AppTextStyle.bodyLarge,
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 6.h),

                            // Amazon Card
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, -2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                child: InkWell(
                                  onTap: () async {
                                    await analytics.buttonClicked(AnalyticsEventNames.marketProductDetailAmazonCardClicked,
                                        AnalyticsScreenNames.kidMarketProductDetailScreenDialog);

                                    ParentPinDialog.show(
                                      onPinSubmit: (pin) async {  // Make this async

                                          final birthYear = int.tryParse(pin);
                                          final currentYear = DateTime.now().year;
                                          final age = currentYear - birthYear!;
                                          if (age >= 21 && age <= 80) {
                                            // Update the PIN in parent state
                                            final updatedParent = appState.currentParent.value?.copyWith(pin: pin);
                                            if (updatedParent != null) {
                                              appState.currentParent.value = updatedParent;
                                             // await _launchProductUrl(product.url);
                                              Get.back();
                                              await _launchProductUrl(product.url);
                                              // Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Please enter a valid birth year (age must be between 21-80)",
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                            );


                                        }
                                      },
                                    );
                                  },
                                  // onTap: () async {
                                  //   await analytics.buttonClicked(AnalyticsEventNames.marketProductDetailAmazonCardClicked,
                                  //       AnalyticsScreenNames.kidMarketProductDetailScreenDialog);
                                  //
                                  //   final currentPin = appState.currentParent.value?.pin;
                                  //   final isFirstTime = currentPin == "";
                                  //
                                  //   ParentPinDialog.show(
                                  //     isFirstTime: isFirstTime,
                                  //     onPinSubmit: (pin) {
                                  //       if (isFirstTime) {
                                  //         // For first time, validate birth year
                                  //         final birthYear = int.tryParse(pin);
                                  //         final currentYear = DateTime.now().year;
                                  //         final age = currentYear - birthYear!;
                                  //         if (age >= 21 && age <= 80) {
                                  //           //TODO: Upload pin to parent
                                  //           // controller.appState.currentParent.value?.pin = pin;
                                  //           _launchProductUrl(product.url);
                                  //           Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                                  //         } else {
                                  //           Fluttertoast.showToast(
                                  //             msg: "Invalid birth year",
                                  //             backgroundColor: Colors.red,
                                  //             textColor: Colors.white,
                                  //           );
                                  //         }
                                  //       } else {
                                  //         // For subsequent times, check against saved PIN
                                  //         if (pin == currentPin) {
                                  //           // switchToParentMode();
                                  //           _launchProductUrl(product.url);
                                  //         } else {
                                  //           Fluttertoast.showToast(
                                  //             msg: "Incorrect PIN",
                                  //             backgroundColor: Colors.red,
                                  //             textColor: Colors.white,
                                  //           );
                                  //         }
                                  //       }
                                  //     },
                                  //   );
                                  // },
                                  //_launchProductUrl(product.url),
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset(
                                              Assets.amazon,
                                              width: 92.w,
                                            ),
                                            Text(
                                              '€${product.price.toStringAsFixed(2)}',
                                              style: AppTextStyle.headingLarge,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Free delivery by Amazon.\nOrder within 2 days.',
                                                style: AppTextStyle.bodyLarge,
                                                maxLines: 2,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(1.w),
                                              decoration: BoxDecoration(
                                                color: AppColors.textPrimary,
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              child: Icon(
                                                Icons.navigate_next,
                                                color: Colors.white,
                                                size: 24.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tap Animation Overlay
          Obx(() {
            if (showPointer.value) {
              return Positioned(
                bottom: 10.h,
                left: 20.w,
                child: HandPointerOverlay(
                  targetKey: _addToGoalKey,
                  onTap: () async {
                    showPointer.value = false;
                    await SharedPreferencesHelper.saveBool(SharedPreferencesHelper.hasSeenAddToGoalTutorial, true);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Future<void> _launchProductUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open product link',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
