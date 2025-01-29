import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/goal_name.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../app_assets.dart';
import '../../../../../theme/color_theme.dart';
import '../../../../../theme/text_theme.dart';
import '../../custom_widgets/kid_text_field.dart';
import '../kid_home_screen.dart';
import 'goal_image.dart';

class KidAddGoalAmount extends StatelessWidget {
  const KidAddGoalAmount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    KidGoalsController kidGoalsController = Get.put(KidGoalsController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            child: SvgPicture.asset(AppAssets.kidSectionBackIconSvg),
          ),
        ),
        actions: [cardContainerIcon()],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.background,
            image: DecorationImage(
              image: AssetImage(AppAssets.kidSectionBG),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'How much does it cost 💸',
                style: AppTextStyle.headingLarge,
              ),
              KidCustomTextField(
                hintText: "000.00 €",
                onChange: (value) {
                  kidGoalsController.goalAmount.value = value;
                },
                keyboardType: TextInputType.numberWithOptions(),
              ),
              kidCustomButton(
                  onTap: () {
                    Get.log(
                        'log: goal goalAmount controller:${kidGoalsController.goalAmount.value}');
                    if (kidGoalsController.goalAmount.value.isNotEmpty) {
                      Get.to(() => KidGoalImage());
                    }
                  },
                  color: Color(0xFF19B859),
                  buttonTitle: 'Next')
            ],
          ),
        ),
      ),
    );
  }
}
