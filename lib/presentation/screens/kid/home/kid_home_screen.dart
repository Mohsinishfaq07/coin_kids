import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/jar_widget.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/dialogs/kid/kid_dialog.dart';
import 'package:coin_kids/presentation/components/kid/parent_zone_widget.dart';
import 'package:coin_kids/presentation/controllers/kid/drag_and_drop_money_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_base_controller.dart';
import 'package:coin_kids/presentation/screens/kid/jars/Jar_color_selection_screen.dart';
import 'package:coin_kids/presentation/screens/kid/jars/drag_and_drop_money_screen.dart';
import 'package:coin_kids/presentation/screens/kid/transfer_between_jars/transfer_between_jars_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class KidHomeScreen extends GetView<KidBaseController> {
  KidHomeScreen({super.key});

  final GlobalKey _moneyJarShowcaseKey = GlobalKey();

  Future<bool> _hasShownMoneyJarShowcase() async {
    return SharedPreferencesHelper.getBool(SharedPreferencesHelper.showcaseMoneyJarKey) ?? false;
  }

  Future<void> _markMoneyJarShowcaseAsShown() async {
    await SharedPreferencesHelper.saveBool(SharedPreferencesHelper.showcaseMoneyJarKey, true);
  }

  void _startShowcase(BuildContext context) async {
    if (!await _hasShownMoneyJarShowcase()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_moneyJarShowcaseKey]);
        _markMoneyJarShowcaseAsShown();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onComplete: (index, key) {
        // Optional: Add any completion logic here
      },
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
                return Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (!isSpendingJarCreated)
                        // Show single null jar when no jars are created
                        Center(
                          child: JarWidget(
                            jarState: JarState.null_jar,
                            jarName: "+",
                            height: 180,
                            onTap: () {
                              controller.startJarCreation(Jars.spendingJar);
                              Get.to(() => JarColorSelectionScreen());
                            },
                            textStyle: AppTextStyle.bodySmall.copyWith(
                              color: AppColors.iconDisabled,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      else
                        // Show created jars and null jar for saving if needed
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Spending/Money Jar with Showcase
                            Showcase(
                              key: _moneyJarShowcaseKey,
                              description: 'This is your Money jar! Tap to add money',
                              targetShapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              targetPadding: EdgeInsets.all(10),
                              tooltipBackgroundColor: AppColors.colorPrimary,
                              textColor: Colors.white,
                              child: JarWidget(
                                jarState: spendingJar.balance > 0 ? JarState.filled : JarState.empty,
                                jarName: "Money",
                                showAmount: true,
                                amount: spendingJar.balance,
                                jarColor: Color(spendingJar.color),
                                height: 180,
                                onTap: () {
                                  Get.to(
                                    () => DragAndDropMoneyScreen(),
                                    arguments: {
                                      'mode': DragAndDropMode.countMoney,
                                      'jarId': Jars.spendingJar.name,
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 50.w),

                            // Transfer Button (show only if both jars exist)
                            if (isSpendingJarCreated && isSavingJarCreated) ...[
                              SizedBox(width: 20.w),
                              KidButton.iconOnly(
                                onTap: () {
                                  Get.to(() => TransferBetweenJarsScreen());
                                },
                                baseColor: AppColors.colorPrimary,
                                iconPath: Assets.icTransfer,
                              ),
                              SizedBox(width: 20.w),
                            ],
                            SizedBox(width: 50.w),
                            // Saving Jar or Null Jar
                            if (isSpendingJarCreated) ...[
                              if (!isSavingJarCreated)
                                JarWidget(
                                  jarState: JarState.null_jar,
                                  jarName: "+",
                                  height: 180,
                                  onTap: () {
                                    controller.startJarCreation(Jars.savingJar);
                                    Get.to(() => JarColorSelectionScreen());
                                  },
                                  textStyle: AppTextStyle.bodySmall.copyWith(
                                    color: AppColors.iconDisabled,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              else
                                JarWidget(
                                  jarState: savingJar.balance > 0 ? JarState.filled : JarState.empty,
                                  jarName: "Saving",
                                  jarColor: Color(savingJar.color),
                                  amount: savingJar.balance,
                                  height: 180,
                                  onTap: () {
                                    showExampleDialog();
                                    // Get.to(
                                    //   () => DragAndDropMoneyScreen(),
                                    //   arguments: {
                                    //     'mode': DragAndDropMode.countMoney,
                                    //     'jarId': Jars.savingJar.name,
                                    //   },
                                    // );
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
                          onTap: () => controller.switchToParentMode(),
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
}
