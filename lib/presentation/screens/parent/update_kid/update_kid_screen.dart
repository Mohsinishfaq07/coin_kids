import 'package:coin_kids/presentation/controllers/parent/add_child_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateKidProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AddChildController addChildController = Get.put(AddChildController());
    return Container();
    // final EditProfileController editProfileController = Get.put(EditProfileController());

    // return Scaffold(
    //   appBar: const CustomAppBar(
    //     title: "Update Child Profile",
    //     showBackButton: true,
    //   ),
    //   body: Container(
    //     decoration: const BoxDecoration(
    //       gradient: AppColors.background,
    //     ),
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 20.w),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             SizedBox(
    //               height: 20.h,
    //             ),
    //             Text(
    //               'Child name',
    //               style: TextStyle(
    //                 color: const Color(0xFF015486),
    //                 fontSize: 14.sp,
    //                 fontFamily: 'Open Sans',
    //                 fontWeight: FontWeight.w700,
    //               ),
    //             ),
    //             SizedBox(
    //               height: 12.h,
    //             ),
    //             Obx(() {
    //               return CustomTextField(
    //                   titleText: "Child name",
    //                   hintText: "Enter your child name",
    //                   controller: editProfileController.childNameController.value,
    //                   onChanged: (val) {
    //                     editProfileController.childNameController.value.text = val.trim();
    //                   });
    //             }),
    //             SizedBox(height: 28.h),
    //             Text(
    //               'Age',
    //               style: TextStyle(
    //                 color: Color(0xFF015486),
    //                 fontSize: 14.sp,
    //                 fontFamily: 'Open Sans',
    //                 fontWeight: FontWeight.w700,
    //               ),
    //             ),
    //             SizedBox(
    //               height: 12.h,
    //             ),
    //             Obx(() {
    //               return CustomTextField(
    //                 titleText: "Age",
    //                 hintText: "Enter child's age",
    //                 keyboardType: TextInputType.number,
    //                 controller: editProfileController.childAgeController.value,
    //                 onChanged: (value) {
    //                   editProfileController.childAgeController.value.text = value.trim();
    //                 },
    //               );
    //             }),
    //             SizedBox(height: 28.h),
    //             Text(
    //               "Select Avatar",
    //               style: TextStyle(
    //                 color: const Color(0xFF015486),
    //                 fontSize: 14.sp,
    //                 fontFamily: 'Open Sans',
    //                 fontWeight: FontWeight.w700,
    //               ),
    //             ),
    //             const SizedBox(height: 10),
    //             Padding(
    //               padding: EdgeInsets.all(6.w),
    //               child: SizedBox(
    //                 height: MediaQuery.of(context).size.height * 0.42.h, // Specify a fixed height
    //                 child: GridView.builder(
    //                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //                     crossAxisCount: 4, // Number of items per row
    //                     crossAxisSpacing: 18, // Space between columns
    //                     mainAxisSpacing: 14, // Space between rows
    //                   ),
    //                   itemCount: addChildController.avatars.length + 1,
    //                   itemBuilder: (context, index) {
    //                     if (index == 0) {
    //                       // First item: Custom Avatar Picker
    //                       return Obx(
    //                         () => GestureDetector(
    //                           onTap: () async {
    //                             //TODO: Unblock
    //                             // showImageSourceBottomSheet(onCameraTap: () {
    //                             //   Get.back(); // Close the bottom sheet
    //                             //   //bottomNavigationBarController.pickFromCamera();
    //                             // }, onGalleryTap: () async {
    //                             //   if (addChildController.kidImagePath.value.isNotEmpty) {
    //                             //     await addChildController.pickImage(source: ImageSource.gallery);
    //                             //     Get.log("Custom Avatar Path: ${addChildController.kidImagePath.value}");
    //                             //   }
    //                             //   // Close the bottom sheet
    //                             //
    //                             //   Get.back();
    //                             //   // bottomNavigationBarController.pickUpFromGallery();
    //                             // });
    //                             // // await addChildController.pickCustomAvatar();
    //                             // // if (addChildController
    //                             // //     .customAvatarPath.value.isNotEmpty) {
    //                             // //   Get.log(
    //                             // //       "Custom Avatar Path: ${addChildController.customAvatarPath.value}");
    //                             // // }
    //                           },
    //                           child: Padding(
    //                             padding: const EdgeInsets.all(6.0),
    //                             child: CircleAvatar(
    //                               radius: 2,
    //                               backgroundColor: Colors.purple,
    //                               backgroundImage: addChildController.kidImagePath.value.isEmpty ? null : FileImage(File(addChildController.kidImagePath.value)),
    //                               child: addChildController.kidImagePath.value.isEmpty
    //                                   ? Center(
    //                                       child: Image.asset(
    //                                         "assets/child_avatar_image_pngs/CameraIcon.png",
    //                                         color: Colors.white,
    //                                       ),
    //                                     )
    //                                   : null,
    //                             ),
    //                           ),
    //                         ),
    //                       );
    //                     } else {
    //                       // Other items: Predefined Avatars
    //                       final avatarIndex = index - 1; // Adjust index for predefined avatars
    //                       return Obx(
    //                         () => GestureDetector(
    //                           onTap: () {
    //                             addChildController.selectAvatar(avatarIndex);
    //                             if (addChildController.kidImagePath.value.isNotEmpty) {
    //                               Get.log("Custom Avatar Path: ${addChildController.selectedAvatarPath.value}");
    //                             }
    //                           },
    //                           child: Padding(
    //                             padding: const EdgeInsets.all(4.0),
    //                             child: Stack(
    //                               alignment: Alignment.center,
    //                               children: [
    //                                 // Avatar Image
    //                                 Container(
    //                                   decoration: BoxDecoration(
    //                                     border: Border.all(
    //                                       color: addChildController.selectedAvatar.value == avatarIndex ? Colors.purple : Colors.transparent,
    //                                     ),
    //                                     borderRadius: BorderRadius.circular(50.r),
    //                                   ),
    //                                   child: Image.asset(
    //                                     addChildController.avatars[avatarIndex],
    //                                     height: 70.h, // Adjust the size of the avatar
    //                                     width: 70.w,
    //                                     fit: BoxFit.fill,
    //                                   ),
    //                                 ),
    //                                 // Centered Check Icon (only when the avatar is selected)
    //                                 if (addChildController.selectedAvatar.value == avatarIndex)
    //                                   Positioned(
    //                                     child: Container(
    //                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.black38, border: Border.all(color: Colors.white)),
    //                                       child: Icon(
    //                                         Icons.check,
    //                                         color: Colors.white,
    //                                         size: 24.sp, // Size of the check icon
    //                                       ),
    //                                     ),
    //                                   ),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                       );
    //                     }
    //                   },
    //                 ),
    //               ),
    //             ),
    //             Center(
    //               child: Obx(() {
    //                 return editProfileController.childUpdate.value
    //                     ? const CircularProgressIndicator()
    //                     : AppButton(
    //                         onPressed: () async {
    //                           if (editProfileController.childNameController.value.text.isEmpty) {
    //                             ToastUtil.showToast('name is required');
    //                           } else {
    //                             final String avatarUrl = addChildController.selectedAvatarPath.value.isEmpty ? addChildController.kidImagePath.value : addChildController.selectedAvatarPath.value;
    //
    //                             updateChildData(
    //                                 childId: childId, name: editProfileController.childNameController.value.text, age: editProfileController.childAgeController.value.text, avatarPath: avatarUrl);
    //                           }
    //                         },
    //                         text: 'Update Child',
    //                       );
    //               }),
    //             ),
    //             const SizedBox(height: 40),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

// updateChildData({
//   required String childId,
//   required String name,
//   required String age,
//   required String avatarPath,
// }) async {
//   final KidService kidService = KidService(); // Create an instance of KidService
//   try {
//     // Create a KidModel instance with the updated data
//     KidModel updatedKid = KidModel(
//       kidId: childId,
//       name: name,
//       age: int.parse(age),
//       // Ensure age is an integer
//       avatar: avatarPath,
//       parentId: '',
//       // Set the parentId if needed
//       wallet: Wallet(
//         savingJar: WalletJar(balance: 0.0, color: '#000000'),
//         spendingJar: WalletJar(balance: 0.0, color: '#000000'),
//       ),
//       coinKidsBalance: 0.0,
//       createdAt: DateTime.now(), // Set the createdAt to now or keep it as is
//     );
//
//     // Call the updateKid method from KidService
//     await kidService.updateKid(childId, updatedKid);
//
//     ToastUtil.showToast('Child info updated');
//     Get.off(() => ParentBaseScreen());
//   } catch (e) {
//     Get.log('Kid update error: ${e.toString()}');
//     ToastUtil.showToast('Failed to update child info: $e');
//   }
// }
}
