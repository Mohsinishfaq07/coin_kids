import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/goal_completed_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/slider.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderWidget extends StatelessWidget {
  final String goalId;

  SliderWidget({
    required this.goalId,
  });

  Stream<QuerySnapshot> _kidsStream() {
    return FirebaseFirestore.instance.collection('kids').snapshots();
  }

  final sliderController = Get.put(SliderController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _kidsStream(),
      builder: (context, kidSnapshot) {
        if (kidSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!kidSnapshot.hasData || kidSnapshot.data!.docs.isEmpty) {
          return Text("No Kids Found");
        }

        final kidId = kidSnapshot.data!.docs.first.id;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('goals')
              .where('kidId', isEqualTo: kidId)
              .where('goalId', isEqualTo: goalId)
              .where('deleted', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text("No Data Found");
            }

            final goal =
                snapshot.data!.docs.first.data() as Map<String, dynamic>?;
            final goalAmount = goal?['amount'] ?? 0.0;
            final goalCurrentAmount = goal?['currentAmount'] ?? 0.0;
            final maxAmount = goalAmount > 0 ? goalAmount.toDouble() : 100.0;

            sliderController.setGoalAmount(maxAmount);

            final currentSliderValue = sliderController.sliderValue.value;
            final completed = goal?['completed'] ?? false;

            if (completed) {
              Future.delayed(Duration.zero, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("This goal is already achieved")),
                );
              });
              return TimelineScreen(); // Navigate or show completed screen
            }

            return Obx(() {
              return SfSliderTheme(
                data: SfSliderThemeData(
                  activeTrackHeight: 20,
                  inactiveTrackHeight: 20,
                ),
                child: SizedBox(
                  width: 320.w, // Adjust size as needed
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
                        )),
                    onChangeStart: (value) => value = firestoreOperations
                        .parentFirebaseFunctions.previousValue.value,

                    enableTooltip: false,

                    activeColor: Colors.blue, // Adjust color
                    inactiveColor: Colors.grey, // Adjust color
                    value: sliderController.sliderValue.value == 0
                        ? goalCurrentAmount
                        : sliderController.sliderValue.value,
                    min: 0,
                    max: maxAmount,
                    stepSize: 0.1,
                    onChanged: (dynamic value) {
                      // Only update the slider value while dragging
                      double newValue = value.toDouble();
                      newValue = newValue.clamp(0.0, maxAmount) as double;
                      sliderController.updateValue(newValue);
                    },
                    onChangeEnd: (dynamic value) async {
                      double newValue = value.toDouble();
                      newValue = newValue.clamp(0.0, maxAmount) as double;

                      sliderController.updateValue(newValue);

                      // Only execute when the slider drag is finished
                      // double newValue = value.toDouble();
                      // newValue = newValue.clamp(0.0, maxAmount) as double;

                      // sliderController.updateValue(newValue);

                      // if (newValue >
                      //     firestoreOperations
                      //         .parentFirebaseFunctions.previousValue.value) {
                      //   ToastUtil.showToast("value is $newValue ");
                      //   await firestoreOperations.parentFirebaseFunctions
                      //       .SpendingTOGoals(
                      //           kidId: kidId,
                      //           enteredAmount: newValue,
                      //           goalId: goalId);
                      //   firestoreOperations
                      //       .parentFirebaseFunctions.previousValue.value = 0.0;
                      // } else if (newValue <
                      //     firestoreOperations
                      //         .parentFirebaseFunctions.previousValue.value) {
                      //   await firestoreOperations.parentFirebaseFunctions
                      //       .GoalsTOSpending(
                      //           kidId: kidId,
                      //           enteredAmount: newValue,
                      //           goalId: goalId);
                      // }
                      // firestoreOperations
                      //     .parentFirebaseFunctions.previousValue.value = 0.0;
                    },
                  ),
                ),
              );
            });
          },
        );
      },
    );
  }
}
