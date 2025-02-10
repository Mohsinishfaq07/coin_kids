import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/goal_completed_screen.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    final kidGoalController = Get.put(KidGoalsController());
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

            kidGoalController.setGoalAmount(maxAmount);

            final currentSliderValue = kidGoalController.sliderValue.value;
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
              double initialSliderValue =
                  0.0; // Store initial position before sliding

              return SfSliderTheme(
                data: SfSliderThemeData(
                  activeTrackHeight: 10.h,
                  inactiveTrackHeight: 10.h,
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
                    // onChangeStart: (value) => value = firestoreOperations
                    //     .parentFirebaseFunctions.previousValue.value,

                    enableTooltip: false,

                    activeColor: Colors.blue, // Adjust color
                    inactiveColor: Colors.grey, // Adjust color
                    value: kidGoalController.sliderValue.value == 0
                        ? goalCurrentAmount // Show stored `currentAmount` first
                        : kidGoalController.sliderValue.value,
                    min: 0,
                    max: maxAmount,
                    stepSize: 0.1,
                    onChangeStart: (dynamic value) {
                      initialSliderValue = value.toDouble();
                    },
                    onChangeEnd: (dynamic value) async {
                      double newValue = value.toDouble();
                      kidGoalController.updateValue(newValue);
                    },
                    onChanged: (dynamic value) {
                      double newValue = value.toDouble();

                      if (newValue > initialSliderValue) {
                        print("[DEBUG] Moving Right → Increasing Value");
                        kidGoalController.isMinus.value = false;
                        kidGoalController.updateValue(newValue);
                        print("newValue is $newValue");
                        // Increase
                      } else if (newValue < initialSliderValue) {
                        print("[DEBUG] Moving Left → Decreasing Value");
                        kidGoalController.isMinus.value = true; // Decrease
                        kidGoalController.updateValue(newValue);
                        print("newValue is $newValue");
                      }

                      kidGoalController.updateValue(newValue);
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
