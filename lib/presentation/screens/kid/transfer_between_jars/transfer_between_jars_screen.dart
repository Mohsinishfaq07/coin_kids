import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/jar_widget.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_transfer_controller.dart';
import 'package:coin_kids/presentation/components/common/hand_pointer_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class TransferBetweenJarsScreen extends GetView<KidTransferController> {
   TransferBetweenJarsScreen({super.key});
  final GlobalKey _spendToSaveKey = GlobalKey();
  final GlobalKey _saveToSpendKey = GlobalKey();
   final RxBool showPointer = true.obs; // You can also use controller variable


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
                                _buildTransferArrow(
                                  key: _spendToSaveKey,
                                  imagePath: Assets.transferToSavingArrow,
                                  onTap: () => controller.handleTransfer(
                                    sourceJar: Jars.spendingJar.name,
                                    targetJar: Jars.savingJar.name,
                                    availableAmount: spendingJar.balance,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                _buildTransferArrow(
                                  key: _saveToSpendKey,
                                  imagePath: Assets.transferToSpendArrow,
                                  onTap: () {
                                    controller.handleTransfer(
                                      sourceJar: Jars.savingJar.name,
                                      targetJar: Jars.spendingJar.name,
                                      availableAmount: savingJar.balance,
                                    );
                                    showPointer.value = false;
                                  },
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
              if (showPointer.value) HandPointerOverlay(
                height: 0.h,
                width: 0.w,
                targetKey: _spendToSaveKey,
                onTap: () {
                  showPointer.value = false;
                },
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
    required Key key,
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
