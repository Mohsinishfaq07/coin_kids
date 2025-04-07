import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/drag_drop_tutorial_overlay.dart';
import 'package:coin_kids/presentation/components/kid/jar_widget.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/kid/drag_and_drop_money_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/kid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

final GlobalKey containerKey = GlobalKey();
final GlobalKey moneyKey = GlobalKey();

class DragAndDropMoneyScreen extends GetView<DragAndDropMoneyController> {
  const DragAndDropMoneyScreen({super.key});

  void _getWidgetCenter(GlobalKey key) {
    RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      Offset position = renderBox.localToGlobal(Offset.zero); // Top-left corner
      Size size = renderBox.size;
      Offset center = position + Offset(size.width / 2, size.height / 2);

      if (key == containerKey) {
        controller.jarOffset.value = center;
        debugPrint("Jar Offset: $center");
      } else {
        debugPrint("Money Offset: $center");
        controller.moneyOffset.value = center;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getWidgetCenter(containerKey);
      _getWidgetCenter(moneyKey);
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: KidAppBarComponent(
        onBackPressed: () {
          _showCancelDialog();
        },
        title: controller.screenTitle,
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.background,
              image: const DecorationImage(image: AssetImage(Assets.kidBg), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.w),
                    child: Row(
                      children: [
                        // Money Type Selector (20% width)
                        SizedBox(
                          width: Get.width * 0.15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                return KidButton.iconOnly(
                                  onTap: () => controller.isShowingBills.value = true,
                                  baseColor: controller.isShowingBills.value ? AppColors.colorPrimary : AppColors.iconDisabled,
                                  iconPath: Assets.icNotes,
                                  size: 60.w,
                                  iconSize: 40.w,
                                );
                              }),
                              SizedBox(height: 20.h),
                              Obx(() {
                                return KidButton.iconOnly(
                                  onTap: () => controller.isShowingBills.value = false,
                                  baseColor: !controller.isShowingBills.value ? AppColors.colorPrimary : AppColors.iconDisabled,
                                  iconPath: Assets.icCoinEuro,
                                  iconSize: 40.w,
                                  size: 60.w,
                                );
                              }),
                            ],
                          ),
                        ),

                        // Draggable Money Items (40% width)
                        Expanded(
                          flex: 2,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final availableWidth = constraints.maxWidth;

                              return Obx(() {
                                final isShowingBills = controller.isShowingBills.value;
                                final rows = isShowingBills ? controller.billRows : controller.coinRows;

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int rowIndex = 0; rowIndex < rows.length; rowIndex++)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            for (final moneyItem in rows[rowIndex])
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
                                                child: SizedBox(
                                                  width: isShowingBills
                                                      ? availableWidth * 0.30.w // Bills are wider
                                                      : rowIndex == 0
                                                          ? availableWidth * 0.25 // Larger coins (€1, €2)
                                                          : availableWidth * 0.2, // Smaller coins
                                                  child: AspectRatio(
                                                    aspectRatio: isShowingBills
                                                        ? 1.8 // Bills are rectangular
                                                        : 1.0, // Coins are circular
                                                    child: _buildDraggableMoney(moneyItem, availableWidth, isShowingBills, rowIndex),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                    ],
                                  ),
                                );
                              });
                            },
                          ),
                        ),

                        // Jar Target Area (40% width)
                        Expanded(
                          flex: 2,
                          child: DragTarget<double>(
                            // onWillAccept: (amount) {
                            //   // This will be called for validation AND allow builder to show colors
                            //   if (amount == null) return false;
                            //   return true; // Always allow to show color feedback
                            // },
                            onWillAcceptWithDetails: (details){
                              return true;
                            },
                            onAcceptWithDetails: (details) async {
                              double amount = details.data;
                              if (controller.canAddAmount(amount)) {
                                await controller.tryAddAmount(amount);
                              }
                            },
                            builder: (context, candidateData, rejectedData) {
                              Color? jarColor;
                              if (candidateData.isNotEmpty) {
                                final proposedAmount = candidateData.first as double;
                                final canAdd = controller.canAddAmount(proposedAmount);
                                jarColor = canAdd ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3);
                              }

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() {
                                    return JarWidget(
                                      key: containerKey,
                                      jarState: controller.jarState.value,
                                      jarName: "",
                                      height: 150.w,
                                      showTag: false,
                                      amount: controller.totalValue.value,
                                      jarColor: jarColor,
                                    );
                                  }),
                                  // Text(
                                  //   '${controller.totalValue}€ total value ',
                                  //   style: AppTextStyle.bodySmall.copyWith(
                                  //     color: Colors.red,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  if (candidateData.isNotEmpty && !controller.canAddAmount(candidateData.first as double))
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: Text(
                                        'Can only add ${controller.remainingAmount}€',
                                        style: AppTextStyle.bodySmall.copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Bar
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      const Spacer(),
                      KidButton.iconOnly(
                        onTap: () => controller.undoLastAmount(),
                        iconPath: Assets.icUndo,
                        baseColor: AppColors.btnColorOrange,
                        size: 50.w,
                      ),
                      SizedBox(width: 32.w),
                      KidButton(
                        onTap: () => controller.handleNextButton(),
                        baseColor: AppColors.btnColorGreen,
                        text: controller.nextButtonText,
                        iconPosition: IconPosition.right,
                        iconPath: Assets.icNext,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tutorial overlay
          Obx(() {
            if (controller.isTutorialPlaying.value && controller.jarOffset.value.dx != 0 && controller.moneyOffset.value.dx != 0) {
              return DragDropTutorialOverlay(
                startPosition: controller.moneyOffset.value,
                endPosition: controller.jarOffset.value,
                onComplete: () => controller.endTutorial(),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    KidDialog.show(
      dismissible: true,
      emoji: Assets.icCoinStar,
      title: controller.cancelTitle.value,
      subtitle: "Do you want to cancel?",
      buttons: [
        KidButton(
          text: "No",
          onTap: () {
            Get.back();
          },
          baseColor: AppColors.btnColorOrange,
          iconPath: Assets.icCross,
          iconPosition: IconPosition.left,
        ),
        SizedBox(width: 16.w),
        KidButton(
          text: "yes",
          onTap: () {
            Get.until((route) => route.settings.name == Routes.kidBase);
          },
          baseColor: AppColors.btnColorGreen,
          iconPath: Assets.icTick,
          iconPosition: IconPosition.left,
        ),
      ],
    );
  }
}

Widget _buildDraggableMoney(MapEntry<String, double> moneyItem, double availableWidth, bool isShowingBills, int rowIndex) {
  final key = moneyItem.value == 5.0 ? moneyKey : null;

  return Draggable<double>(
    key: key,
    // Add the key here
    data: moneyItem.value,
    feedback: Material(
      color: Colors.transparent,
      child: SizedBox(
        width: isShowingBills
            ? availableWidth * 0.35.w
            : rowIndex == 0
                ? availableWidth * 0.3
                : availableWidth * 0.25,
        child: _buildMoneyItem(moneyItem, isDragging: true),
      ),
    ),
    childWhenDragging: _buildMoneyItem(moneyItem, isGhost: true),
    child: _buildMoneyItem(moneyItem),
  );
}

Widget _buildMoneyItem(MapEntry<String, double> moneyItem, {bool isDragging = false, bool isGhost = false}) {
  final opacity = isGhost ? 0.5 : 1.0;

  return Opacity(
    opacity: opacity,
    child: Image.asset(
      moneyItem.key,
      fit: BoxFit.contain,
    ),
  );
}
