import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/screens/parent/transfer/quick_transfer.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/screens/parent/update_kid_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class KidProfileManagementPageController extends GetxController {
  final KidService _kidService = KidService();
  final RxString currentType = 'jarType'.obs;
  final Rx<KidModel?> currentKid = Rx<KidModel?>(null);
  final RxBool isLoading = false.obs;

  Future<void> loadKidData(String kidId) async {
    try {
      isLoading.value = true;
      currentKid.value = await _kidService.fetchKidById(kidId);
    } catch (e) {
      print('Error loading kid data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class KidProfileManagementPage extends StatelessWidget {
  final String kidId;
  final KidProfileManagementPageController controller =
      Get.put(KidProfileManagementPageController());

  KidProfileManagementPage({super.key, required this.kidId}) {
    // Load kid data when page is created
    controller.loadKidData(kidId); // Pass the kidId to load the correct data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${controller.currentKid.value?.name ?? 'Loading...'}'s Profile",
        centerTitle: true,
        showBackButton: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final kid = controller.currentKid.value;
            if (kid == null) {
              return const Center(child: Text('No kid data available'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                childGeneralDetailWidget(kid: kid, context: context),
                Padding(
                  padding: EdgeInsets.only(top: 45.h, bottom: 46.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      kidMainButtons(
                        title: 'Quick\nTransfer',
                        assetPath: 'assets/kidManageIcons/quickTransfer.svg',
                        onTap: () => Get.to(() => QuickTransferPage(
                              kidId: kidId,
                              docData: kid.toJson(),
                            )),
                      ),
                      kidMainButtons(
                        title: 'Schedule\nAllowance',
                        assetPath:
                            'assets/kidManageIcons/scheduleAllowance.svg',
                        onTap: () {
                          ToastUtil.showToast("Coming soon...");
                        },
                      ),
                      kidMainButtons(
                        title: 'Edit\nProfile',
                        assetPath: 'assets/kidManageIcons/editProfile.svg',
                        onTap: () => Get.to(() => UpdateKidProfile(
                              childId: kidId,
                              childAge: kid.age.toString(),
                              childAvatar: kid.avatar,
                              childName: kid.name,
                            )),
                      )
                    ],
                  ),
                ),
                // Type switcher row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTypeSwitcher(
                          'jarType', 'assets/kidManageIcons/coin.svg'),
                      _buildTypeSwitcher(
                          'notificationType', 'assets/Frame.svg'),
                      _buildTypeSwitcher(
                          'goalType', 'assets/kidManageIcons/goalIcon.svg'),
                    ],
                  ),
                ),
                // Content based on selected type
                Obx(() {
                  switch (controller.currentType.value) {
                    case 'jarType':
                      return _buildWalletInfo(kid.wallet);
                    case 'notificationType':
                      return notificationData(childId: kidId);
                    case 'goalType':
                      return goalsData(childId: kidId);
                    default:
                      return const SizedBox();
                  }
                }),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTypeSwitcher(String type, String assetPath) {
    return Obx(() => typeSwitcherContainer(
          containerColor: controller.currentType.value == type
              ? Colors.purple
              : const Color(0xFFEDFAFF),
          assetPath: assetPath,
          onTap: () => controller.currentType.value = type,
          topRight: type == 'goalType' ? 10.0 : 0.0,
          bottomRight: type == 'goalType' ? 10.0 : 0.0,
          topLeft: type == 'jarType' ? 10.0 : 0.0,
          bottomLeft: type == 'jarType' ? 10.0 : 0.0,
        ));
  }

  Widget _buildWalletInfo(Wallet wallet) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Savings Jar
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/kidManageIcons/savingJar.svg',
                height: 100.h,
                width: 100.w,
              ),
              SizedBox(height: 20.h),
              Text(
                'Savings: €${wallet.savingJar.balance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
          // Spending Jar
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/kidManageIcons/spendingJar.svg',
                height: 100.h,
                width: 100.w,
              ),
              SizedBox(height: 20.h),
              Text(
                'Spending: €${wallet.spendingJar.balance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget childGeneralDetailWidget(
      {required KidModel kid, required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(top: 36.h),
      child: Center(
        child: Container(
          width: 126.w,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: ShapeDecoration(
            color: const Color(0xFFEDFAFF),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.w, color: const Color(0xFFCBE4F3)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 6,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(kid.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 14.sp)),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundImage: kid.avatar.startsWith('/')
                      ? FileImage(File(kid.avatar))
                      : kid.avatar.startsWith('assets') &&
                              !kid.avatar.endsWith('.svg')
                          ? AssetImage(kid.avatar) as ImageProvider
                          : kid.avatar.startsWith('http')
                              ? NetworkImage(kid.avatar)
                              : null,
                  child: kid.avatar.endsWith('.svg')
                      ? SvgPicture.asset(kid.avatar, fit: BoxFit.cover)
                      : null,
                ),
              ),
              Text(
                'Available Money',
                style: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: 12.sp,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "€${kid.wallet.spendingJar.balance.toStringAsFixed(2)}",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // kid profile main buttons
  kidMainButtons(
      {required String title,
      required String assetPath,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            assetPath,
          ),
          const SizedBox(height: 3),
          Text(title,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // type switcher container
  typeSwitcherContainer({
    required Color containerColor,
    required String assetPath,
    required Function() onTap,
    required double topRight,
    required double bottomRight,
    required double topLeft,
    required double bottomLeft,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(Get.context!).width / 3.5,
        decoration: BoxDecoration(
          color: containerColor,
          border: Border.all(color: Colors.grey, width: 0.5.w),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft),
            topRight: Radius.circular(topRight),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: SvgPicture.asset(
            assetPath,
            height: 22.h,
            width: 22.w,
          ),
        ),
      ),
    );
  }

  // notifications data
  Widget notificationData({required String childId}) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('childId', isEqualTo: childId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/messages.svg',
                    height: 100.h,
                    width: 100.w,
                  ),
                ),
                SizedBox(height: 26.h),
                SizedBox(
                  width: 312.w,
                  child: Text(
                    'No Messages!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF015486),
                      fontSize: 18.sp,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                      height: 2.45.h,
                    ),
                  ),
                )
              ],
            );
          }

          final goals = snapshot.data!.docs;

          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              var goalData = goals[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/kidManageIcons/goalIcon.svg',
                    height: 40,
                    width: 40,
                  ),
                  title: Text(
                    goalData['title'] ?? 'No Title',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    goalData['description'] ?? 'No Description',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // goals data
  Widget goalsData({required String childId}) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('goals')
            .where('childId', isEqualTo: childId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/clap.png',
                    height: 95.h,
                    width: 95.w,
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 312.w,
                  child: Text(
                    'No Saving Goal Created!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18.sp,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                      height: 2.45.h,
                    ),
                  ),
                )
              ],
            );
          }

          final goals = snapshot.data!.docs;

          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              var goalData = goals[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    goalData['image'],
                    height: 40,
                    width: 40,
                  ),
                  title: Text(
                    goalData['name'] ?? 'No Title',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    goalData['amount'] ?? 'No Description',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
