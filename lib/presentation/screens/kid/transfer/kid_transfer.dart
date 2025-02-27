import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/components/kid/jar_with_money.dart';
import 'package:coin_kids/presentation/components/kid/jar_without_money.dart';
import 'package:coin_kids/presentation/components/kid/kid_back_button.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';

import 'package:coin_kids/presentation/controllers/kid/add_money_controller.dart';
import 'package:coin_kids/presentation/screens/kid/transfer/transfer_by_drag.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KidTransferScreen extends StatelessWidget {
  KidTransferScreen({super.key});

  final addMoneyController = Get.put(AddMoneyController());
  final KidService _kidService = Get.find<KidService>();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      extendBody: true,
      body: StreamBuilder<List<KidModel>>(
        stream: _kidService.streamKids(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final List<KidModel> kids = snapshot.data!;
          if (kids.isEmpty) {
            return const Center(child: Text('No kid data found'));
          }

          final KidModel kid = kids.first;
          final spendingAmount = kid.wallet.spendingJar.balance;
          final spendingJarColor = kid.wallet.spendingJar.color;
          final savingAmount = kid.wallet.savingJar.balance;
          final savingJarColor = kid.wallet.savingJar.color;

          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.background,
              image: DecorationImage(
                image: AssetImage(AppAssets.kidSectionBG),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            kidBackButton(onTap: () => Get.back()),
                            SizedBox(width: 20.w),
                            Text("Kid Transfer",
                                style: AppTextStyle.headingLarge)
                          ]),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Spending Jar
                      if (spendingAmount != 0)
                        JarWithMoneyTitle(
                          JarTitle: 'Spendings',
                          color: spendingJarColor,
                          amount: spendingAmount,
                        )
                      else
                        JarWithoutMoneyTitle(
                          JarTitle: 'Spendings',
                          amount: spendingAmount,
                        ),

                      // Transfer Arrows
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Column(
                          children: [
                            // Spending to Saving Arrow
                            GestureDetector(
                              onTap: () {
                                if (spendingAmount != 0) {
                                  Get.to(TransferByDrag(isSpending: false.obs));
                                } else {
                                  ToastUtil.showToast('Not Enough Funds');
                                }
                              },
                              child: Image.asset(
                                "assets/arrow_saving.png",
                                width: 130.w,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            // Saving to Spending Arrow
                            GestureDetector(
                              onTap: () {
                                if (savingAmount != 0) {
                                  Get.to(TransferByDrag(isSpending: true.obs));
                                } else {
                                  ToastUtil.showToast('Not Enough Funds');
                                }
                              },
                              child: Image.asset(
                                "assets/arow_spending.png",
                                width: 130.w,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Saving Jar
                      if (savingAmount != 0)
                        JarWithMoneyTitle(
                          JarTitle: 'Savings',
                          color: savingJarColor,
                          amount: savingAmount,
                        )
                      else
                        JarWithoutMoneyTitle(
                          JarTitle: 'Savings',
                          amount: savingAmount,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
