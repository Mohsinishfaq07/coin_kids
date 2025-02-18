import 'package:coin_kids/firebase/firebase_authentication/firebase_auth.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/coin_kid_lock_container.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/total_money_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/kid_add_goal_section/kid_avatar_container.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/spending_card_container.dart';
import 'package:coin_kids/pages/roles/parents/authentication/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class KidDefaultAppBar extends StatelessWidget {
  final FirebaseAuthController firebaseAuthController =
      Get.find<FirebaseAuthController>();

  KidDefaultAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kid's Avatar Container
          KidAvatarContainer(),

          // Logout Button
          GestureDetector(
            onTap: () async {
              await firebaseAuthController.logout();
              // Navigate to Login screen after logout
              Get.offAll(() => LoginScreen());
            },
            child: Icon(Icons.logout, color: Colors.red),
          ),

          // Row for cards and balance widgets
          Row(
            children: [
              SpendingCardContainer(),
              SizedBox(width: 20.w),
              coinKidLockContainer(),
              SizedBox(width: 20.w),
              totalBalanceWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
