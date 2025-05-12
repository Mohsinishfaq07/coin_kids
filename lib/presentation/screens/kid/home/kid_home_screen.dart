import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/overlay/hand_pointer_overlay.dart';
import 'package:coin_kids/presentation/components/kid/jar_widget.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/kid/parent_zone_widget.dart';
import 'package:coin_kids/presentation/controllers/kid/drag_and_drop_money_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_base_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/parent_pin_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as product;
import 'package:showcaseview/showcaseview.dart';

class KidHomeScreen extends GetView<KidBaseController> {
  const KidHomeScreen({super.key});
  void _calculatePointerPosition() {
    final RenderBox? renderBox = GlobalKeys.transferButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      // Calculate the position for the pointer (center-right of the arrow)
      final pointerX = position.dx + size.width - 30.w;
      final pointerY = position.dy + (size.height / 2) - 30.h;

      controller.pointerPosition.value = Offset(pointerX, pointerY);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculatePointerPosition();
    });
    return ShowCaseWidget(
      onComplete: (index, key) {
        controller.showJarShowcase.value = false;
        controller.markMoneyJarShowcaseAsShown();
      },
      builder: (context) {
        return Obx(
          () {
            final kid = controller.currentKid.value;
            if (kid == null) {
              return const SizedBox.shrink();
            }

            final spendingJar = kid.wallet.spendingJar;
            final savingJar = kid.wallet.savingJar;
            final isSpendingJarCreated = spendingJar.color != 0;
             final isSavingJarCreated = savingJar.color != 0;


            // Check showcase conditions only when the widget is first built
            if (!controller.hasInitializedShowcase.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (controller.shouldShowJarSpotLight() && !controller.isNotificationShowing.value) {
                  controller.startShowcase(context);
                }
                controller.hasInitializedShowcase.value = true;
              });
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: GestureDetector(
                    onTap: () async {
                      if (controller.showTransferPointer.value) {
                        controller.showTransferPointer.value = false;

                        await controller.markTransferTutorialAsShown();
                      }
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (!isSpendingJarCreated)
                          // Show single null jar when no jars are created
                          Center(
                            child: Showcase(
                              key: controller.moneyJarShowcaseKey,
                              description: getSpotlightDescription(),
                              targetShapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              targetPadding: EdgeInsets.all(10),
                              tooltipBackgroundColor: AppColors.colorPrimary,
                              textColor: Colors.white,
                              disableBarrierInteraction: false,
                              child: JarWidget(
                                jarState: JarState.nullJar,
                                jarName: "+ Add Money",
                                height: 0.45.sh,
                                onTap: () async {
                                  final isConnected = controller.appState.currentKid.value!.isConnected;
                                  final kidBalance = controller.appState.currentKid.value!.wallet.spendingJar.balance;

                                  if (isConnected && kidBalance <= 0) {
                                    // KidDialog.show(
                                    //   emoji: Assets.icEmojiMessage,
                                    //   title: "Woohoo! Parent Connected 🎈",
                                    //   subtitle: "Your parent is connected, please request money",
                                    //   buttons: [
                                    //     KidButton(
                                    //       text: "Ok",
                                    //       onTap: () => Get.back(),
                                    //       baseColor: AppColors.btnColorGreen,
                                    //       iconPath: Assets.icTick,
                                    //       iconPosition: IconPosition.left,
                                    //     ),
                                    //   ],
                                    //
                                    // );
                                    ToastUtil.showToast("Your parent is connected, please request money");
                                    return;
                                  }
                                  await controller.analytics.buttonClicked(
                                    AnalyticsEventNames.kidMoneyJarCreatedClicked,
                                    AnalyticsScreenNames.kidHomeScreen,
                                    AnalyticsScreenNames.kidJarColorSelection,
                                  );
                                  controller.startJarCreation(Jars.spendingJar);
                                  Get.toNamed(Routes.kidJarColorSelection);
                                },
                                textStyle: AppTextStyle.bodySmall.copyWith(
                                  color: AppColors.iconDisabled,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          )
                        else
                          // Show created jars and null jar for saving if needed
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Spending/Money
                              JarWidget(
                                jarState: spendingJar.balance > 0 ? JarState.filled : JarState.empty,
                                jarName: "Money",
                                showAmount: true,
                                amount: spendingJar.balance,
                                jarColor: Color(spendingJar.color),
                                height: 0.45.sh,
                                onTap: () async {
                                  await controller.analytics
                                      .buttonClicked(AnalyticsEventNames.kidMoneyJarClicked, AnalyticsScreenNames.kidHomeScreen);

                                  if (spendingJar.balance <= 0) {
                                    return;
                                  }

                                  // Get.toNamed(
                                  //   Routes.kidDragAndDrop,
                                  //   arguments: {
                                  //     'mode': DragAndDropMode.countMoney,
                                  //     'jarId': Jars.spendingJar.name,
                                  //   },
                                  // );
                                },
                              ),
                              SizedBox(width: 0.05.sw),

                              // Transfer Button (show only if both jars exist)
//                            //  if (isSpendingJarCreated && isSavingJarCreated) ...[
                              if (isSpendingJarCreated && isSavingJarCreated && controller.showSavingJar == false.obs) ...[
                                SizedBox(width: 20.w),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    KidButton.iconWithTitle(
                                      key: GlobalKeys.transferButtonKey,
                                      onTap: () async {
                                        await controller.analytics.buttonClicked(AnalyticsEventNames.kidTransferButtonClicked,
                                            AnalyticsScreenNames.kidHomeScreen, AnalyticsScreenNames.kidTransferAmountScreen);

                                        controller.showTransferPointer.value = false;
                                        await controller.markTransferTutorialAsShown();

                                        Get.toNamed(Routes.kidMoneyTransfer);
                                      },
                                      baseColor: AppColors.colorPrimary,
                                      iconPath: Assets.icTransfer,
                                      title: 'Transfer',
                                    ),
                                    Obx(() {
                                      if (controller.showTransferPointer.value) {
                                        return Positioned(
                                          child: HandPointerOverlay(
                                            targetKey: GlobalKeys.transferButtonKey,
                                            onTap: () async {
                                              controller.showTransferPointer.value = false;
                                              await controller.markTransferTutorialAsShown();
                                            },
                                            width: 60.w,
                                            height: 60.w,
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    }),
                                  ],
                                ),
                                SizedBox(width: 20.w),
                              ],
                              SizedBox(width: 0.05.sw),
                              // Saving Jar or Null Jar
                              // if (isSpendingJarCreated  ) ...[
                              if (isSpendingJarCreated && isSavingJarCreated && controller.showSavingJar == false.obs) ...[

                                if (!isSavingJarCreated )
                                  JarWidget(
                                    jarState: JarState.nullJar,
                                    jarName: "+ Add Savings",
                                    height: 0.45.sh,
                                    onTap: () async {
                                      await controller.analytics.buttonClicked(AnalyticsEventNames.kidSavingJarCreatedClicked,
                                          AnalyticsScreenNames.kidHomeScreen, AnalyticsScreenNames.kidJarColorSelection);

                                      controller.startJarCreation(Jars.savingJar);
                                      Get.toNamed(Routes.kidJarColorSelection);
                                    },
                                    textStyle: AppTextStyle.bodySmall.copyWith(
                                      color: AppColors.iconDisabled,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  )
                                else
                                  JarWidget(
                                    jarState: savingJar.balance > 0 ? JarState.filled : JarState.empty,
                                    jarName: "Saving",
                                    jarColor: Color(savingJar.color),
                                    amount: savingJar.balance,
                                    height: 0.45.sh,
                                    onTap: () async {
                                      await controller.analytics
                                          .buttonClicked(AnalyticsEventNames.kidSavingJarClicked, AnalyticsScreenNames.kidHomeScreen);

                                      if (savingJar.balance <= 0) {
                                        return;
                                      }
                                      // Get.toNamed(
                                      //   Routes.kidDragAndDrop,
                                      //   arguments: {
                                      //     'mode': DragAndDropMode.countMoney,
                                      //     'jarId': Jars.savingJar.name,
                                      //   },
                                      // );
                                    },
                                  ),
                              ],
                              //Negate Navigation Rail Effect to push content to center
                              // SizedBox(width: 40.w),
                            ],
                          ),

                        // Parent Zone Button
                        Positioned(
                          bottom: 0.h,
                          right: 20.w,
                          child: GestureDetector(
                            onTap: () async {
                              await controller.analytics.buttonClicked(
                                AnalyticsEventNames.switchToParentClicked,
                                AnalyticsScreenNames.kidHomeScreen,
                                AnalyticsScreenNames.parentBase,
                              );

                              ParentPinDialog.show(
                                onPinSubmit: (pin) async {
                                  final birthYear = int.tryParse(pin);
                                  final currentYear = DateTime.now().year;
                                  final age = currentYear - birthYear!;
                                  if (age >= 21 && age <= 80) {
                                     Get.back(); // Wait for dialog to dismiss
                                    await Future.delayed(const Duration(milliseconds: 100)); // Small delay to ensure dialog is gone
                                    controller.switchToParentMode();
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
                            child: ParentZoneWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String getSpotlightDescription() {
    if (controller.appState.currentKid.value!.isConnected) {
      //Parent exists
      if (controller.appState.currentKid.value!.wallet.spendingJar.balance == 0) {
        //Show spotlight on AddMoney
        return "You don't have money, Let's Request Money from parent";
      } else {
        //Received Money from parent
        return "Yohooo! You have spending money. Let's Add it to Money Jar";
      }
    } else {
      //Parent doesn't exists
      return "Let's get started by creating a Money Jar";
    }
  }
}
