import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/core/extention/number_extensions.dart';
import 'package:coin_kids/presentation/components/kid/green_next_button.dart';
import 'package:coin_kids/presentation/components/kid/kid_back_button.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/kid/spending_card_container.dart';
import 'package:coin_kids/presentation/controllers/kid/add_money_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/jar_creation_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/delete_dialog.dart';
import 'package:coin_kids/presentation/screens/kid/home/kid_home_screen.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/presentation/screens/kid/jars/widgets/half_circle_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class AddMoneyScreen extends GetView<JarCreationController> {
  final RxBool isSpending;
  final double amount;
  final Color jarColor;

  AddMoneyScreen(
      {required this.isSpending,
      required this.amount,
      required this.jarColor,
      super.key});

  final addMoneyController = Get.put(AddMoneyController());

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBody: true,
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
                if (kidsData.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                final Map<String, dynamic> kidData =
                    kidsData[0].data() as Map<String, dynamic>;
                final Map<String, dynamic> spendingData =
                    kidData.containsKey('spendings')
                        ? kidData['spendings'] as Map<String, dynamic>
                        : {};
                (spendingData['amount'] ?? 0.0).toDouble();
                final String spendingJarColor =
                    (spendingData['color'] ?? "").toString();

                // Ensure "savings" field exists, otherwise provide default values
                final Map<String, dynamic> savingsData =
                    kidData.containsKey('savings')
                        ? kidData['savings'] as Map<String, dynamic>
                        : {};
                print("$savingsData");

                (savingsData['amount'] ?? 0.0).toDouble();
                final String savingJarColor =
                    (savingsData['color'] ?? "#000000").toString();

                // Ensure "spendings" field exists, otherwise provide default values

                print("Spending jar color: $spendingJarColor");
                print("Saving jar color: $savingJarColor");
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.background,
                    image: DecorationImage(
                        image: AssetImage(AppAssets.kidSectionBG),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              kidBackButton(
                                onTap: () {
                                  showDeleteGoalDialog(
                                    imageAsset: "assets/clap.png",

                                    context,
                                    label:
                                        "Cancel transfer", // The title of the dialog
                                    subLabel:
                                        "Do you want to cancel Transfer?", // The subtitle
                                    YesonTap: () async {
                                      addMoneyController.totalValue.value =
                                          0.0;
                                      Get.back();
                                    }, // The action to take on "Yes" button click
                                  );
                                },
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                "Add money",
                                style: AppTextStyle.headingLarge,
                              )
                            ]),
                            SpendingCardContainer(),
                          ],
                        ),
                      ),
                      // SizedBox(height: 16.h),
                      Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             //  HalfCircleWithButtonsWidget(clickedIndex: addMoneyController.clickedIndex, onButtonTap: (index) {
                             // addMoneyController.   clickedIndex.value = index;  // Update the clicked index
                             //  },),

                              SizedBox(
                                // width: 10.w,
                              ),
                              Obx(() {
                                // Dynamically display widget based on button click
                                if (addMoneyController.clickedIndex.value ==
                                    0) {
                                  return SizedBox(
                                    width: 150.w,
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              2, // Number of columns
                                          childAspectRatio: 2.w,
                                          crossAxisSpacing:
                                              6.h, // Space between columns
                                          mainAxisSpacing:
                                              8.h, // Space between rows
                                        ),
                                        itemCount:
                                            addMoneyController.notesMap.length,
                                        itemBuilder: (context, index) {
                                          // Get the key-value pair from the map
                                          var noteAsset = addMoneyController
                                              .notesMap.keys
                                              .elementAt(index);

                                          return Draggable<String>(
                                            data:
                                                noteAsset, // The data being dragged (asset path)
                                            feedback: Material(
                                              color: Colors.transparent,
                                              child: Image.asset(
                                                noteAsset, // Use the asset path from the map
                                                height: 60.h,
                                                width: 120.w,
                                              ),
                                            ),
                                            childWhenDragging: Opacity(
                                              opacity: 0.5,
                                              child: Image.asset(
                                                  noteAsset), // Image when dragging
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                noteAsset, // Image to display in the grid
                                                height: 60.h,
                                                width: 120.w,
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                                } else if (addMoneyController
                                        .clickedIndex.value ==
                                    1) {
                                  return SizedBox(
                                    width: 150.w,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // First List
                                        GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 1.w,
                                            crossAxisSpacing: 14.w,
                                          ),
                                          itemCount: addMoneyController
                                              .firstCoinList.length,
                                          itemBuilder: (context, index) {
                                            var coinAsset = addMoneyController
                                                .firstCoinList.keys
                                                .elementAt(index);

                                            return Draggable<String>(
                                              data: coinAsset,
                                              feedback: Material(
                                                color: Colors.transparent,
                                                child: Image.asset(
                                                  coinAsset,
                                                  height: 70.h,
                                                  width: 120.w,
                                                ),
                                              ),
                                              childWhenDragging: Opacity(
                                                opacity: 0.5,
                                                child: Image.asset(coinAsset),
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  coinAsset,
                                                  height: 100.h,
                                                  width: 120.w,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        // Second List
                                        GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 1.w,
                                            crossAxisSpacing: 4.h,
                                            // mainAxisSpacing: 8.h,
                                          ),
                                          itemCount: addMoneyController
                                              .secondCoinList.length,
                                          itemBuilder: (context, index) {
                                            var secondCoinAsset =
                                                addMoneyController
                                                    .secondCoinList.keys
                                                    .elementAt(index);
                                            return Draggable<String>(
                                              data: secondCoinAsset,
                                              feedback: Material(
                                                color: Colors.transparent,
                                                child: Image.asset(
                                                  secondCoinAsset,
                                                  height: 60.h,
                                                  width: 120.w,
                                                ),
                                              ),
                                              childWhenDragging: Opacity(
                                                opacity: 0.5,
                                                child: Image.asset(
                                                    secondCoinAsset),
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  secondCoinAsset,
                                                  height: 60.h,
                                                  width: 120.w,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        // Third List
                                        GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 2.w,
                                            crossAxisSpacing: 0.w,
                                          ),
                                          itemCount: addMoneyController
                                              .thirdCoinList.length,
                                          itemBuilder: (context, index) {
                                            var thirdCoinAsset =
                                                addMoneyController
                                                    .thirdCoinList.keys
                                                    .elementAt(index);
                                            return Draggable<String>(
                                              data: thirdCoinAsset,
                                              feedback: Material(
                                                color: Colors.transparent,
                                                child: Image.asset(
                                                  thirdCoinAsset,
                                                  height: 60.h,
                                                  width: 120.w,
                                                ),
                                              ),
                                              childWhenDragging: Opacity(
                                                opacity: 0.5,
                                                child:
                                                    Image.asset(thirdCoinAsset),
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  thirdCoinAsset,
                                                  height: 60.h,
                                                  width: 120.w,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              }),
                              // SizedBox(
                              //   width: 58.w,
                              // ),
                              Column(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        addMoneyController.undoLastDrop();
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF9E29),
                                          borderRadius: BorderRadius.circular(
                                              30.r), // Rounded corners
                                          border: Border.all(
                                            width: 2.22.w,
                                            color: const Color(0xFFD67513),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 12.w,
                                              right: 12.w,
                                              top: 4.h,
                                              bottom: 4.h,
                                              child: Center(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .transparent, // Background color (optional)
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.2), // Shadow color
                                                        blurRadius:
                                                            10, // Blur radius for the shadow
                                                        offset: const Offset(2,
                                                            4), // Shadow position (x, y)
                                                      ),
                                                    ],
                                                    shape: BoxShape
                                                        .circle, // Optional: Change to BoxShape.rectangle for a rectangular shadow
                                                  ),
                                                  child: SvgPicture.asset(
                                                    "assets/undo.svg",
                                                    height: 20.h,
                                                    width: 20.w,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                left: 0.5,
                                                top: 0.29,
                                                child: Image.asset(
                                                  AppAssets.button_shadow_png,
                                                  height: 8.h,
                                                )),
                                          ],
                                        ),
                                      )),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    "undo",
                                    style: AppTextStyle.bodyLarge,
                                  )
                                ],
                              ),
                              // SizedBox(
                              //   width: 20.w,
                              // ),
                              DragTarget<String>(
                                onAcceptWithDetails: (data) {
                                  addMoneyController.onNoteDropped(
                                      data.data); // Update total value
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
                                  return Obx(() {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(children: [
                                          Image.asset(
                                            addMoneyController
                                                        .totalValue.value >
                                                    0
                                                ? "assets/filledJar.png"
                                                : "assets/emptyJar.png",
                                            height: 90.h,
                                            width: 130.w,
                                            color: candidateData.isNotEmpty
                                                ? Colors.green.withOpacity(0.5)
                                                : null, // Highlight effect when dragging over
                                          ),
                                          Positioned(
                                              bottom: 0.h,
                                              left: 24.w,
                                              child: Center(
                                                child: Container(
                                                  width: 88.85.w,
                                                  height: 16.h,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 2.69.w,
                                                      vertical: 2.h),
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          width: 1.53.w,
                                                          color: Color(
                                                              0xFF015486)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              51.33.r),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color:
                                                            Color(0x3F6169D3),
                                                        blurRadius: 2.60,
                                                        offset:
                                                            Offset(-1.30, 1.95),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                  child: addMoneyController
                                                              .totalValue
                                                              .value >
                                                          0
                                                      ? Marquee(
                                                          text:
                                                              addMoneyController.totalValue.value.toMoneyFormat(),
                                                          decelerationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      500),
                                                          decelerationCurve:
                                                              Curves.easeOut,
                                                          velocity: 10.0,
                                                          accelerationDuration:
                                                              Duration(
                                                                  seconds: 1),
                                                          accelerationCurve:
                                                              Curves.linear,
                                                          pauseAfterRound:
                                                              Duration(
                                                                  seconds: 1),
                                                          blankSpace: 7 *
                                                              15.83.sp *
                                                              0.6,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF015486),
                                                            fontSize: 15.83.sp,
                                                            fontFamily:
                                                                'Open Sans',
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        )
                                                      : Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        addMoneyController.totalValue.value.toMoneyFormat(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF015486),
                                                                      fontSize:
                                                                          15.83
                                                                              .sp,
                                                                      fontFamily:
                                                                          'Open Sans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: '€',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF015486),
                                                                      fontSize:
                                                                          15.83
                                                                              .sp,
                                                                      fontFamily:
                                                                          'Open Sans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              )),
                                        ]),
                                      ],
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                          Positioned(
                            left: -80.w,
                            child: Stack(
                              children: [
                                HalfCircleWidget(),
                                Positioned(
                                  right:
                                  0, // Aligns the child to the right corner
                                  top: 0, // Aligns the child to the top
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start, // Aligns buttons to the top
                                    children: [
                                      // First Button
                                      GestureDetector(
                                        onTap: () {
                                          addMoneyController
                                              .clickedIndex.value = 0;
                                        },
                                        child: Obx(() {
                                          final isSelected =
                                              addMoneyController
                                                  .clickedIndex.value ==
                                                  0;

                                          return isSelected
                                              ? AvatarGlow(
                                            glowRadiusFactor: 0.3.r,
                                            startDelay:
                                            const Duration(
                                                seconds: 2),
                                            repeat: true,
                                            glowCount: 2,
                                            glowShape:
                                            BoxShape.circle,
                                            animate:
                                            true, // Glow only when selected
                                            duration: const Duration(
                                                seconds: 2),
                                            glowColor: AppColors
                                                .buttonPrimary,
                                            child: _buildButton(
                                              isSelected,
                                              assetPath:
                                              "assets/notes.svg", // Customize icon
                                            ),
                                          )
                                              : _buildButton(
                                            isSelected,
                                            assetPath:
                                            "assets/notes.svg", // Customize icon
                                          );
                                        }),
                                      ),
                                      SizedBox(height: 20.h),
                                      // Second Button
                                      GestureDetector(
                                        onTap: () {
                                          addMoneyController
                                              .clickedIndex.value = 1;
                                        },
                                        child: Obx(() {
                                          final isSelected =
                                              addMoneyController
                                                  .clickedIndex.value ==
                                                  1;

                                          return isSelected
                                              ? AvatarGlow(
                                            glowRadiusFactor: 0.3.r,
                                            startDelay:
                                            const Duration(
                                                seconds: 2),
                                            repeat: true,
                                            glowCount: 2,
                                            glowShape:
                                            BoxShape.circle,
                                            animate:
                                            true, // Glow only when selected
                                            duration: const Duration(
                                                seconds: 2),
                                            glowColor: AppColors
                                                .buttonPrimary,
                                            child: _buildButton(
                                              isSelected,
                                              assetPath:
                                              "assets/Coin.svg", // Customize icon
                                            ),
                                          )
                                              : _buildButton(
                                            isSelected,
                                            assetPath:
                                            "assets/Coin.svg", // Customize icon
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.w, top: 10.h),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: GreenNextButton(
                                showSuffix: true,
                                onTap: () async {
                                  if (isSpending == true) {
                                    if (addMoneyController.totalValue.value ==
                                        amount) {
                                      print('Amounts match!');
                                      final kid = controller
                                          .appState.currentKid.value!;

                                      await controller.kidService
                                          .updateSpendingJarBalance(
                                              kid.kidId, amount,
                                              color: jarColor.value);

                                      addMoneyController.totalValue.value =
                                          0.0;
                                      Get.off(() => KidHomeScreen());
                                    } else {
                                      ToastUtil.showToast(
                                        "Total value does not match spending amount!",
                                      );
                                    }
                                  } else {
                                    if (addMoneyController.totalValue.value ==
                                        amount) {
                                      print('Amounts match!');
                                      final kid = controller
                                          .appState.currentKid.value!;
                                      await controller.kidService
                                          .updateSavingJarBalance(
                                              kid.kidId, amount,
                                              color: jarColor.value);
                                      // await authController
                                      //     .parentFirebaseFunctions
                                      //     .kidSpendingToSavings(
                                      //   save: false,
                                      //   enteredAmount: widget.amount,
                                      //       kid.parentId,
                                      //   savingsJarColor: widget.jarColor,
                                      // );
                                      addMoneyController.totalValue.value =
                                          0.0;
                                      Get.off(() => KidHomeScreen());
                                    } else {
                                      ToastUtil.showToast(
                                        "Total value does not match savings amount!",
                                      );
                                    }
                                  }
                                },
                                buttonText: "Next")),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}

Widget _buildButton(bool isSelected, {required String assetPath}) {
  return Container(
    decoration: BoxDecoration(
      color: isSelected ? AppColors.buttonPrimary : AppColors.primaryLightColor,
      border: Border.all(
        color:
            isSelected ? AppColors.buttonPrimary : AppColors.primaryLightColor,
      ),
      borderRadius: BorderRadius.circular(30.r),
    ),
    child: Padding(
      padding: EdgeInsets.all(4.h),
      child: CircleAvatar(
        backgroundColor:
            isSelected ? AppColors.buttonPrimary : AppColors.primaryLightColor,
        child: SvgPicture.asset(
          assetPath,
          height: 20.h,
          width: 37.w,
        ),
      ),
    ),
  );
}

// Import your controller

class RightHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(size.width / 2, 0); // Start from the middle of the top
    path.arcTo(
      Rect.fromLTWH(0, 0, size.width, size.height), // Full oval bounds
      -pi / 2, // Start angle (top center)
      pi, // Sweep angle (half circle to the bottom center)
      false,
    );
    path.lineTo(size.width / 2, size.height); // Closing the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HalfCircleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RightHalfCircleClipper(), // Clip the right half circle
      child: Container(
        width: 155.w, // Set the width for the right half-circle
        height: 80.h, // Set the height for the right half-circle
        // color: Colors.blue, // Fill color for the right half-circle
        child: CustomPaint(
          painter: RightHalfCircleBorderPainter(),
        ),
      ),
    );
  }
}

class RightHalfCircleBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xFFC0E1EB) // Border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Border thickness

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, -pi / 2, pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
