import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/presentation/components/kid/goal_completed_screen.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderWidget extends StatelessWidget {
  final String goalId;
  final String kidId;

  SliderWidget({
    required this.goalId,
    required this.kidId,
  });

  @override
  Widget build(BuildContext context) {
    final kidGoalController = Get.put(KidGoalsController());
    final GoalService _goalService = Get.find<GoalService>();

    return StreamBuilder<GoalModel?>(
      stream: _goalService.streamGoal(goalId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final goal = snapshot.data;
        if (goal == null) {
          print("[DEBUG] No goal found for goalId: $goalId");
          return const Text("No Goal Found");
        }

        final goalAmount = goal.targetAmount;
        final goalCurrentAmount = goal.savedAmount;
        final maxAmount = goalAmount > 0 ? goalAmount : 100.0;

        kidGoalController.setGoalAmount(maxAmount);

        if (goal.status == GoalStatus.completed) {
          Future.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("This goal is already achieved")),
            );
          });
          return TimelineScreen();
        }

        return Obx(() {
          return SfSliderTheme(
            data: SfSliderThemeData(
              activeTrackHeight: 10.h,
              inactiveTrackHeight: 10.h,
            ),
            child: SizedBox(
              width: 320.w,
              child: SfSlider(
                shouldAlwaysShowTooltip: true,
                showTicks: true,
                showLabels: true,
                edgeLabelPlacement: EdgeLabelPlacement.auto,
                thumbIcon: CircleAvatar(
                  backgroundColor: AppColors.buttonPrimary,
                  radius: 20.r,
                  child: SvgPicture.asset(
                    "assets/Coin.svg",
                    height: 40.h,
                  ),
                ),
                enableTooltip: false,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                value: kidGoalController.sliderValue.value == 0
                    ? goalCurrentAmount
                    : kidGoalController.sliderValue.value,
                min: 0,
                max: maxAmount,
                stepSize: 0.1,
                onChangeStart: (value) {
                  kidGoalController.initialSliderValue = value.toDouble();
                },
                onChangeEnd: (value) async {
                  kidGoalController.updateValue(value.toDouble());
                },
                onChanged: (value) {
                  double newValue = value.toDouble();
                  if (newValue > kidGoalController.initialSliderValue) {
                    kidGoalController.isMinus.value = false;
                    kidGoalController.updateValue(newValue);
                  } else if (newValue < kidGoalController.initialSliderValue) {
                    kidGoalController.isMinus.value = true;
                    kidGoalController.updateValue(newValue);
                  }
                  kidGoalController.updateValue(newValue);
                },
              ),
            ),
          );
        });
      },
    );
  }
}
