import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/presentation/components/kid/jar_widget.dart';
import 'package:coin_kids/presentation/components/parent/empty_state.dart';
import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class JarsTabWidget extends GetView<KidProfileController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final kid = controller.appState.currentKid.value;
      if (kid == null) return const SizedBox.shrink();

      final spendingJar = kid.wallet.spendingJar;
      final savingJar = kid.wallet.savingJar;
      final isSpendingJarCreated = spendingJar.color != 0;
      final isSavingJarCreated = savingJar.color != 0;

      if (!isSpendingJarCreated) {
        return Expanded(
          child: Center(child: buildJarEmptyState()),
        );
      }

      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            JarWidget(
              jarState: spendingJar.balance > 0 ? JarState.filled : JarState.empty,
              jarName: "Money",
              jarColor: Color(spendingJar.color),
              amount: spendingJar.balance,
              showAmount: true,
            ),


            if(isSavingJarCreated) SizedBox(width: 30.w),

            if(isSavingJarCreated) JarWidget(
              jarState: savingJar.balance > 0 ? JarState.filled : JarState.empty,
              jarName: "Saving",
              jarColor: Color(savingJar.color),
              amount: savingJar.balance,
              showAmount: true,
            ),

          ],
        ),
      );
    });
  }
}
