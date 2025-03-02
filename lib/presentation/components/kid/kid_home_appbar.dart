import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/presentation/components/kid/coin_kid_lock_container.dart';
import 'package:coin_kids/presentation/components/kid/total_money_widget.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/login_screen.dart';
import 'package:coin_kids/presentation/screens/kid/goals/kid_avatar_container.dart';
import 'package:coin_kids/presentation/components/kid/spending_card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KidDefaultAppBar extends StatelessWidget {
  final AuthService _authService = Get.find<AuthService>();

  KidDefaultAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 4.h),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Kid's Avatar Container
            KidAvatarContainer(),
        
            // Logout Button
            GestureDetector(
              onTap: () async {
                await _authService.signOut();
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
      ),
    );
  }
}
