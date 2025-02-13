// class EditGoal extends StatefulWidget {
//   // ... existing code ...
// }
//
// class _EditGoalState extends State<EditGoal> {
//   final isLoading = false.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     // Load saved image when widget initializes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       kidGoalsController.loadSavedImage(widget.goalId);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: 100.h,
//           width: 270.w,
//           padding: EdgeInsets.all(10.w),
//           decoration: BoxDecoration(
//             color: AppColors.primaryLightColor.withOpacity(0.2),
//             border: Border.all(color: AppColors.buttonPrimary),
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           child: Center(
//             child: StreamBuilder<QuerySnapshot>(
//               // ... your existing StreamBuilder code ...
//               builder: (context, kidSnapshot) {
//                 // ... existing builder code ...
//                 return StreamBuilder<QuerySnapshot>(
//                   // ... your existing nested StreamBuilder ...
//                   builder: (context, goalSnapshot) {
//                     if (goalSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     }
//
//                     if (!goalSnapshot.hasData ||
//                         goalSnapshot.data!.docs.isEmpty) {
//                       return AddGoalWidget();
//                     }
//
//                     return Obx(() {
//                       if (isLoading.value) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//
//                       return Center(
//                         child: kidGoalsController.goalImage.value.isNotEmpty
//                             ? Container(
//                                 height: 80.h,
//                                 width: 200.w,
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                     image: FileImage(
//                                       File(kidGoalsController.goalImage.value),
//                                     ),
//                                     fit: BoxFit.cover,
//                                   ),
//                                   borderRadius: BorderRadius.circular(20.r),
//                                 ),
//                               )
//                             : Center(
//                                 child: Column(
//                                     // ... your existing camera/gallery buttons ...
//                                     ),
//                               ),
//                       );
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//         ),
//         Positioned(
//           top: -0,
//           right: -0,
//           child: GestureDetector(
//             onTap: () async {
//               isLoading.value = true;
//               await kidGoalsController.removeImageFromPrefs(widget.goalId);
//               kidGoalsController.goalImage.value = "";
//               isLoading.value = false;
//             },
//             child: SvgPicture.asset(
//               AppAssets.crossSvg,
//               width: 22.w,
//               height: 22.h,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
