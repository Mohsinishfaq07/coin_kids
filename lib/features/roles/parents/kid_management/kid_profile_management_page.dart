import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/roles/parents/kid_management/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class KidProfileManagementPageController extends GetxController {
  // current type
  RxString currentType = 'jarType'.obs;
}

class KidProfileManagementPage extends StatelessWidget {
  const KidProfileManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    KidProfileManagementPageController kidProfileManagementPageController =
        Get.put(KidProfileManagementPageController());
    return Scaffold(
      appBar: CustomAppBar(title: "Child Name"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            childGeneralDetailWidget(),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  kidMainButtons(
                      title: 'Quick\nTransfer',
                      assetPath: 'assets/kidManageIcons/quickTransfer.svg',
                      onTap: () {}),
                  kidMainButtons(
                      title: 'Schedule\nAllowance',
                      assetPath: 'assets/kidManageIcons/scheduleAllowance.svg',
                      onTap: () {}),
                  kidMainButtons(
                      title: 'Edit\nProfile',
                      assetPath: 'assets/kidManageIcons/editProfile.svg',
                      onTap: () {
                        Get.to(() => const EditProfile());
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  typeSwitcherContainer(
                      containerColor: Colors.purple,
                      assetPath: 'assets/kidManageIcons/coin.svg',
                      onTap: () {
                        kidProfileManagementPageController.currentType.value =
                            'jarType';
                        Get.log(kidProfileManagementPageController
                            .currentType.value);
                      },
                      topRight: 0.0,
                      bottomRight: 0.0,
                      topLeft: 10.0,
                      bottomLeft: 10.0),
                  typeSwitcherContainer(
                    containerColor: Colors.purple,
                    assetPath: 'assets/kidManageIcons/bellIcon.svg',
                    onTap: () {
                      kidProfileManagementPageController.currentType.value =
                          'notificationType';
                      Get.log(
                          kidProfileManagementPageController.currentType.value);
                    },
                    topRight: 0.0,
                    bottomRight: 0.0,
                    topLeft: 0.0,
                    bottomLeft: 0.0,
                  ),
                  typeSwitcherContainer(
                    containerColor: Colors.purple,
                    assetPath: 'assets/kidManageIcons/goalIcon.svg',
                    onTap: () {
                      kidProfileManagementPageController.currentType.value =
                          'goalType';
                      Get.log(
                          kidProfileManagementPageController.currentType.value);
                    },
                    topRight: 10.0,
                    bottomRight: 10.0,
                    topLeft: 0.0,
                    bottomLeft: 0.0,
                  ),
                ],
              ),
            ),

            // type data

            Obx(() {
              return emptyTypeData(
                assetPath: kidProfileManagementPageController
                            .currentType.value ==
                        'jarType'
                    ? 'assets/kidManageIcons/jarIcon.svg'
                    : kidProfileManagementPageController.currentType.value ==
                            'notificationType'
                        ? 'assets/kidManageIcons/bellLargeIcon.svg'
                        : 'assets/kidManageIcons/goalLargeIcon.svg',
                line: kidProfileManagementPageController.currentType.value ==
                        'jarType'
                    ? 'Your child has not set any jars yet'
                    : kidProfileManagementPageController.currentType.value ==
                            'notificationType'
                        ? 'No Notifications'
                        : 'Your child has not set any goals yet',
              );
            })
          ],
        ),
      ),
    );
  }
}

childGeneralDetailWidget() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          // name
          const Text('child name'),
          // avatar
          Image.asset('assets/avatar1.png'),
          // available money
          const Text('Available Money'),
          const Text('Rs 600'),
        ]),
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
            style: const TextStyle(
              fontSize: 12,
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
  return Container(
    width: MediaQuery.sizeOf(Get.context!).width / 3.5,
    decoration: BoxDecoration(
      color: containerColor,
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      ),
    ),
    child: GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          assetPath,
          height: 25,
          width: 25,
        ),
      ),
    ),
  );
}

// Expanded type ui  this ui will be fetched from firebase with help of stream builder of live updates

emptyTypeData({required String assetPath, required String line}) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SvgPicture.asset(
            assetPath,
            height: 100,
            width: 100,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(line,
            style: const TextStyle(
              fontSize: 12,
            ),
            textAlign: TextAlign.center),
      ],
    ),
  );
}
