import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/jar_widget.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_transfer_controller.dart';
import 'package:coin_kids/presentation/components/kid/overlay/hand_pointer_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class TransferBetweenJarsScreen extends GetView<KidTransferController> {
   const TransferBetweenJarsScreen({super.key});


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: KidAppBarComponent(
        title: "Transfer Money",
        onBackPressed: () => Get.back(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.background,
          image: const DecorationImage(
            image: AssetImage(Assets.kidBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(() {
          final currentKid = controller.appState.currentKid.value;
          if (currentKid == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final spendingJar = currentKid.wallet.spendingJar;
          final savingJar = currentKid.wallet.savingJar;

          return Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          JarWidget(
                            jarState: spendingJar.balance > 0 ? JarState.filled : JarState.empty,
                            jarName: "Money",
                            showAmount: true,
                            amount: spendingJar.balance,
                            jarColor: Color(spendingJar.color),
                            height: 0.45.sh,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    _buildTransferArrow(
                                      key: GlobalKeys.spendToSaveKey,
                                      imagePath: Assets.transferToSavingArrow,
                                      onTap: () async {
                                        await controller.markTransferTutorialAsShown();
                                        controller.handleTransfer(
                                          sourceJar: Jars.spendingJar.name,
                                          targetJar: Jars.savingJar.name,
                                          availableAmount: spendingJar.balance,
                                        );
                                      },
                                    ),
                                    Obx(() {
                                      if (controller.showPointer.value) {
                                        return Positioned(
                                          right: -10.w,
                                          bottom: -10.h,
                                          child: HandPointerOverlay(
                                            targetKey: GlobalKeys.spendToSaveKey,
                                            onTap: () async {
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
                                SizedBox(height: 30.h),
                                _buildTransferArrow(
                                  imagePath: Assets.transferToSpendArrow,
                                  onTap: () => controller.handleTransfer(
                                    sourceJar: Jars.savingJar.name,
                                    targetJar: Jars.spendingJar.name,
                                    availableAmount: savingJar.balance,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          JarWidget(
                            jarState: savingJar.balance > 0 ? JarState.filled : JarState.empty,
                            jarName: "Saving",
                            showAmount: true,
                            amount: savingJar.balance,
                            jarColor: Color(savingJar.color),
                            height: 0.45.sh,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTransferArrow({
    required String imagePath,
    required VoidCallback onTap,
     Key? key,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Image.asset(
        imagePath,
        height: 0.15.sh,
      ),
    );
  }
}
