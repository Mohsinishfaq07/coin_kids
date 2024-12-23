import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/pages/roles/parents/kid_management/edit_profile.dart';
import 'package:coin_kids/pages/roles/parents/kid_management/quick_transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class KidProfileManagementPageController extends GetxController {
  // current type
  RxString currentType = 'jarType'.obs;
}

class KidProfileManagementPage extends StatelessWidget {
  final String childId;
  final dynamic docData;

  const KidProfileManagementPage(
      {super.key, required this.childId, this.docData});

  @override
  Widget build(BuildContext context) {
    KidProfileManagementPageController kidProfileManagementPageController =
        Get.put(KidProfileManagementPageController());

    final DocumentReference kidDocRef =
        FirebaseFirestore.instance.collection('kids').doc(childId);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Quick Transfer",
        centerTitle: false,
        showBackButton: true,
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: kidDocRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No data found'));
            } else {
              var docData = snapshot.data!.data() as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  childGeneralDetailWidget(docData: docData, context: context),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        kidMainButtons(
                            title: 'Quick\nTransfer',
                            assetPath:
                                'assets/kidManageIcons/quickTransfer.svg',
                            onTap: () {
                              Get.to(() => QuickTransferPage(
                                    docData: docData,
                                    childId: childId,
                                  ));
                            }),
                        kidMainButtons(
                            title: 'Schedule\nAllowance',
                            assetPath:
                                'assets/kidManageIcons/scheduleAllowance.svg',
                            onTap: () {}),
                        kidMainButtons(
                            title: 'Edit\nProfile',
                            assetPath: 'assets/kidManageIcons/editProfile.svg',
                            onTap: () {
                              Get.to(() => EditProfile(
                                    childId: childId,
                                    childAge: docData['age'] ?? '1',
                                    childGrade: docData['grade'],
                                    childAvatar: docData['avatar'],
                                  ));
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          return typeSwitcherContainer(
                              containerColor: kidProfileManagementPageController
                                          .currentType.value ==
                                      'jarType'
                                  ? Colors.purple
                                  : Colors.transparent,
                              assetPath: 'assets/kidManageIcons/coin.svg',
                              onTap: () {
                                kidProfileManagementPageController
                                    .currentType.value = 'jarType';
                                Get.log(kidProfileManagementPageController
                                    .currentType.value);
                              },
                              topRight: 0.0,
                              bottomRight: 0.0,
                              topLeft: 10.0,
                              bottomLeft: 10.0);
                        }),
                        Obx(() {
                          return typeSwitcherContainer(
                            containerColor: kidProfileManagementPageController
                                        .currentType.value ==
                                    'notificationType'
                                ? Colors.purple
                                : Colors.transparent,
                            assetPath: 'assets/kidManageIcons/bellIcon.svg',
                            onTap: () {
                              kidProfileManagementPageController
                                  .currentType.value = 'notificationType';
                              Get.log(kidProfileManagementPageController
                                  .currentType.value);
                            },
                            topRight: 0.0,
                            bottomRight: 0.0,
                            topLeft: 0.0,
                            bottomLeft: 0.0,
                          );
                        }),
                        Obx(() {
                          return typeSwitcherContainer(
                            containerColor: kidProfileManagementPageController
                                        .currentType.value ==
                                    'goalType'
                                ? Colors.purple
                                : Colors.transparent,
                            assetPath: 'assets/kidManageIcons/goalIcon.svg',
                            onTap: () {
                              kidProfileManagementPageController
                                  .currentType.value = 'goalType';
                              Get.log(kidProfileManagementPageController
                                  .currentType.value);
                            },
                            topRight: 10.0,
                            bottomRight: 10.0,
                            topLeft: 0.0,
                            bottomLeft: 0.0,
                          );
                        })
                      ],
                    ),
                  ),

                  // if relevant type is empty  data
                  // Obx(() {
                  //   return emptyTypeData(
                  //     assetPath: kidProfileManagementPageController
                  //                 .currentType.value ==
                  //             'jarType'
                  //         ? 'assets/kidManageIcons/jarIcon.svg'
                  //         : kidProfileManagementPageController
                  //                     .currentType.value ==
                  //                 'notificationType'
                  //             ? 'assets/kidManageIcons/bellLargeIcon.svg'
                  //             : 'assets/kidManageIcons/goalLargeIcon.svg',
                  //     line: kidProfileManagementPageController
                  //                 .currentType.value ==
                  //             'jarType'
                  //         ? 'Your child has not set any jars yet'
                  // : kidProfileManagementPageController
                  //             .currentType.value ==
                  //         'notificationType'
                  //             ? 'No Notifications'
                  //             : 'Your child has not set any goals yet',
                  //   );
                  // })
                  Obx(() {
                    return kidProfileManagementPageController
                                .currentType.value ==
                            'jarType'
                        ? jarData(childId: childId)
                        : kidProfileManagementPageController
                                    .currentType.value ==
                                'notificationType'
                            ? notificationData(childId: childId)
                            : goalsData(childId: childId);
                  }),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

childGeneralDetailWidget(
    {required dynamic docData, required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.only(top: 30.0),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            // name
            Text(docData['name'],
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 16)),

            // avatar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/child_avatar_images/avatar2.svg'),
            ),
            // available money
            const Text(
              'Available Money',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            Text(docData['savings']['amount'],
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 16)),
          ]),
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

// jar data

Widget jarData({required String childId}) {
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('kids') // Access the 'kids' collection
        .doc(childId) // Fetch document where ID matches childId
        .snapshots(),
    builder: (context, snapshot) {
      // Loading State
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      // Error State
      if (snapshot.hasError) {
        return const Center(
          child: Text('Failed to load jar data!'),
        );
      }

      // Check if document does not exist or has no data
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/kidManageIcons/jarIcon.svg',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your child has not set any jars yet',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      // Extract data from the document
      var jarData = snapshot.data!.data() as Map<String, dynamic>;

      // Fetch savings and spending amounts, fallback to '0' if missing
      final savingsAmount = jarData['savings']?['amount']?.toString() ?? '0';
      final spendingAmount = jarData['spendings']?['amount']?.toString() ?? '0';

      // Return the UI with savings and spendings displayed
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Savings Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/kidManageIcons/savingJar.svg',
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Savings: \$ $savingsAmount',
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            // Spendings Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/kidManageIcons/spendingJar.svg',
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Spendings: \$ $spendingAmount',
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

//notifications data
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
                  'assets/kidManageIcons/bellLargeIcon.svg',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No Notifications',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
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
                child: SvgPicture.asset(
                  'assets/kidManageIcons/goalLargeIcon.svg',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your child has not set any goals yet',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
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
