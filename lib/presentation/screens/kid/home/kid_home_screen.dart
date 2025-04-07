import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/jar_widget.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/kid/parent_zone_widget.dart';
import 'package:coin_kids/presentation/controllers/kid/drag_and_drop_money_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class KidHomeScreen extends GetView<KidBaseController> {
  KidHomeScreen({super.key});

  final GlobalKey _moneyJarShowcaseKey = GlobalKey();

  Future<void> _markMoneyJarShowcaseAsShown() async {
    await SharedPreferencesHelper.saveBool(
        SharedPreferencesHelper.showcaseMoneyJarKey, true);
  }

  void _startShowcase(BuildContext context) async {
    if (controller.shouldShowJarSpotLight()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_moneyJarShowcaseKey]);
        controller.showJarShowcase.value = false;
        _markMoneyJarShowcaseAsShown();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onComplete: (index, key) {},
      builder: (context) {
        _startShowcase(context);

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

            return LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (!isSpendingJarCreated)
                        // Show single null jar when no jars are created
                        Center(
                          child: Showcase(
                            key: _moneyJarShowcaseKey,
                            description: getSpotlightDescription(),
                            targetShapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            targetPadding: EdgeInsets.all(10),
                            tooltipBackgroundColor: AppColors.colorPrimary,
                            textColor: Colors.white,
                            child: JarWidget(
                              jarState: JarState.nullJar,
                              jarName: "+ Add Money",
                              height: 0.45.sh,
                              onTap: () {
                                final isConnected = controller
                                    .appState.currentKid.value!.isConnected;
                                final kidBalance = controller
                                    .appState
                                    .currentKid
                                    .value!
                                    .wallet
                                    .spendingJar
                                    .balance;

                                if (isConnected && kidBalance <= 0) {
                                  ToastUtil.showToast(
                                      "Your parent is connected, please request money");
                                  return;
                                }

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
                              jarState: spendingJar.balance > 0
                                  ? JarState.filled
                                  : JarState.empty,
                              jarName: "Money",
                              showAmount: true,
                              amount: spendingJar.balance,
                              jarColor: Color(spendingJar.color),
                              height: 0.45.sh,
                              onTap: () {
                                if (spendingJar.balance <= 0) {
                                  return;
                                }
                                Get.toNamed(
                                  Routes.kidDragAndDrop,
                                  arguments: {
                                    'mode': DragAndDropMode.countMoney,
                                    'jarId': Jars.spendingJar.name,
                                  },
                                );
                              },
                            ),
                            SizedBox(width: 0.05.sw),

                            // Transfer Button (show only if both jars exist)
                            if (isSpendingJarCreated && isSavingJarCreated) ...[
                              SizedBox(width: 20.w),
                              KidButton.iconWithTitle(
                                onTap: () {
                                  Get.toNamed(Routes.kidMoneyTransfer);
                                },
                                baseColor: AppColors.colorPrimary,
                                iconPath: Assets.icTransfer,
                                title: 'Transfer',
                              ),
                              SizedBox(width: 20.w),
                            ],
                            SizedBox(width: 0.05.sw),
                            // Saving Jar or Null Jar
                            if (isSpendingJarCreated) ...[
                              if (!isSavingJarCreated)
                                JarWidget(
                                  jarState: JarState.nullJar,
                                  jarName: "+ Add Savings",
                                  height: 0.45.sh,
                                  onTap: () {
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
                                  jarState: savingJar.balance > 0
                                      ? JarState.filled
                                      : JarState.empty,
                                  jarName: "Saving",
                                  jarColor: Color(savingJar.color),
                                  amount: savingJar.balance,
                                  height: 0.45.sh,
                                  onTap: () {
                                    if (savingJar.balance <= 0) {
                                      return;
                                    }
                                    Get.toNamed(
                                      Routes.kidDragAndDrop,
                                      arguments: {
                                        'mode': DragAndDropMode.countMoney,
                                        'jarId': Jars.savingJar.name,
                                      },
                                    );
                                  },
                                ),
                            ],
                            //Negate Navigation Rail Effect to push content to center
                            SizedBox(width: 40.w),
                          ],
                        ),

                      // Parent Zone Button
                      Positioned(
                        bottom: 0.h,
                        right: 20.w,
                        child: GestureDetector(
                          onTap: () {
                            controller.switchToParentMode();
                            // final currentPin = controller.appState.currentParent.value?.pin;
                            // final isFirstTime = currentPin == null;
                            //
                            //
                            // ParentPinDialog.show(
                            //   isFirstTime: isFirstTime,
                            //   onPinSubmit: (pin) {
                            //     if (isFirstTime) {
                            //       // For first time, validate birth year
                            //       final birthYear = int.tryParse(pin);
                            //       if (birthYear != null && DateTime.now().year - birthYear >= 25) {
                            //         //TODO: Upload pin to parent
                            //         // controller.appState.currentParent.value?.pin = pin;
                            //         controller.switchToParentMode();
                            //       } else {
                            //         Fluttertoast.showToast(
                            //           msg: "Invalid birth year",
                            //           backgroundColor: Colors.red,
                            //           textColor: Colors.white,
                            //         );
                            //       }
                            //     } else {
                            //       // For subsequent times, check against saved PIN
                            //       if (pin == currentPin) {
                            //         controller.switchToParentMode();
                            //       } else {
                            //         Fluttertoast.showToast(
                            //           msg: "Incorrect PIN",
                            //           backgroundColor: Colors.red,
                            //           textColor: Colors.white,
                            //         );
                            //       }
                            //     }
                            //   },
                            // );
                          },
                          child: ParentZoneWidget(),
                        ),
                      ),
                    ],
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
      if (controller.appState.currentKid.value!.wallet.spendingJar.balance ==
          0) {
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
