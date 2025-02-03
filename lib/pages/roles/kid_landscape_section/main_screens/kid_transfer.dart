import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/jar_with_money.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/jar_without_money.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/kid_back_button.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/add_money_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/transfer_by_drag.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:coin_kids/theme/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class KidTransferScreen extends StatelessWidget {
  KidTransferScreen({super.key});

  final addMoneyController = Get.put(AddMoneyController());

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('kids')
                .where('parentId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return CircularProgressIndicator();
              else if (snapshot.hasError)
                return Text(snapshot.error.toString());
              else {
                final List<QueryDocumentSnapshot> kidsData =
                    snapshot.data!.docs;
                print("kidsdata is $kidsData");
                final Map<String, dynamic> kidData =
                    kidsData[0].data() as Map<String, dynamic>;
                final Map<String, dynamic> spendingData =
                    kidData.containsKey('spendings')
                        ? kidData['spendings'] as Map<String, dynamic>
                        : {};
                final double spendingAmount =
                    (spendingData['amount'] ?? 0.0).toDouble();
                final String spendingJarColor =
                    (spendingData['color'] ?? "").toString();

                // Ensure "savings" field exists, otherwise provide default values
                final Map<String, dynamic> savingsData =
                    kidData.containsKey('savings')
                        ? kidData['savings'] as Map<String, dynamic>
                        : {};
                print("$savingsData");

                final double savingAmount =
                    (savingsData['amount'] ?? 0.0).toDouble();
                final String savingJarColor =
                    (savingsData['color'] ?? "#000000").toString();

                // Ensure "spendings" field exists, otherwise provide default values
                final Map<String, dynamic> spendingsData =
                    kidData.containsKey('spendings')
                        ? kidData['spendings'] as Map<String, dynamic>
                        : {};

                print("Spending jar color: $spendingJarColor");
                print("Saving jar color: $savingJarColor");

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
                                  kidBackButton(
                                    onTap: () {
                                      Get.back();
                                    },
                                  ),
                                  SizedBox(width: 20.w),
                                  Text(
                                    "Kid Transfer",
                                    style: AppTextStyle.headingLarge,
                                  )
                                ]),
                                // GestureDetector(
                                //     onTap: () {},
                                //     child: CircleAvatar(
                                //       backgroundColor: AppColors.buttonPrimary,
                                //       maxRadius: 26.w,
                                //       child: Container(
                                //         width: 35,
                                //         height: 35,
                                //         clipBehavior: Clip.antiAlias,
                                //         decoration: BoxDecoration(
                                //           color: const Color(0xFFFF9E29),
                                //           borderRadius: BorderRadius.circular(
                                //               30.r), // Rounded corners
                                //           border: Border.all(
                                //             width: 2.22.w,
                                //             color: const Color(0xFFD67513),
                                //           ),
                                //         ),
                                //         child: Stack(
                                //           children: [
                                //             Positioned(
                                //               left: 5.w,
                                //               top: 4.h,
                                //               // bottom: 4.h,
                                //               child: Center(
                                //                 child: Container(
                                //                   decoration: BoxDecoration(
                                //                     color: Colors
                                //                         .transparent, // Background color (optional)
                                //                     boxShadow: [
                                //                       BoxShadow(
                                //                         color: Colors.black
                                //                             .withOpacity(
                                //                                 0.2), // Shadow color
                                //                         blurRadius:
                                //                             10, // Blur radius for the shadow
                                //                         offset: Offset(2,
                                //                             4), // Shadow position (x, y)
                                //                       ),
                                //                     ],
                                //                     shape: BoxShape
                                //                         .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                                //                   ),
                                //                   child: SvgPicture.asset(
                                //                     AppAssets.kidCrossIcons,
                                //                     fit: BoxFit.cover,
                                //                     height: 10.h,
                                //                   ),
                                //                 ),
                                //               ),
                                //             ),
                                //             Positioned(
                                //                 left: 0.1.w,
                                //                 top: 0.1.h,
                                //                 child: Image.asset(
                                //                   "assets/Button_shadow.png",
                                //                   height: 5.h,
                                //                 )),
                                //           ],
                                //         ),
                                //       ),
                                //     ))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (kidsData.isNotEmpty) ...[
                              (() {
                                if (spendingAmount != 0) {
                                  return JarWithMoneyTitle(
                                    JarTitle: 'Spendings',
                                    color: spendingJarColor,
                                    amount: spendingAmount,
                                  );
                                }
                                // If spendingAmount is greater than 0, show jar with spending amount
                                else {
                                  return JarWithoutMoneyTitle(
                                    JarTitle: 'Spendings',
                                    amount: spendingAmount,
                                  );
                                }
                              })(),
                            ],
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (spendingAmount != 0) {
                                        Get.to(TransferByDrag(
                                            isSpending: true.obs));
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              'Not Enough Funds', // Message to display
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor:
                                              AppColors.textHighlighted,
                                          textColor: Colors.white,
                                          fontSize: 16.sp,
                                        );
                                      }
                                    },
                                    child: Image.asset(
                                      "assets/arrow_saving.png",
                                      width: 130.w,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (savingAmount != 0) {
                                        Get.to(TransferByDrag(
                                            isSpending: false.obs));
                                      } else {
                                        //show toast
                                        Fluttertoast.showToast(
                                          msg:
                                              'Not Enough Funds', // Message to display
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor:
                                              AppColors.textHighlighted,
                                          textColor: Colors.white,
                                          fontSize: 16.sp,
                                        );
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
                            if (kidsData.isNotEmpty) ...[
                              (() {
                                if (savingAmount != 0) {
                                  return JarWithMoneyTitle(
                                    JarTitle: 'savings',
                                    color: savingJarColor,
                                    amount: savingAmount,
                                  );
                                }
                                // If spendingAmount is greater than 0, show jar with spending amount
                                else {
                                  return JarWithoutMoneyTitle(
                                    JarTitle: 'Savings',
                                    amount: savingAmount,
                                  );
                                }
                              })(),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
