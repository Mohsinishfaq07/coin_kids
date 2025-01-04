import 'package:coin_kids/pages/roles/kid/kid_drawer.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class KidMyMoney extends StatelessWidget {
  KidMyMoney({super.key});
  final ParentHomeController parentController =
      Get.put(ParentHomeController()); // Ensure controller is initialized

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
            onTap: () {
               Get.to(
                    KidDrawer(),
                    transition:
                        Transition.leftToRightWithFade, // Custom transition
                    duration:
                        const Duration(milliseconds: 300), // Animation duration
                  );
            },
            child: CircleAvatar(
              child: Image.asset('assets/child_avatar_image_pngs/Frame1.png'),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  parentController.kidName.value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 10),
                )),
            Text("Welcome 👋", style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
        actions: [
          SizedBox(
            width: 100.0,
            child: Row(
              children: [
                Text(
                  '00.00',
                  style: GoogleFonts.openSans(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffA421D9)),
                  textAlign: TextAlign.left,
                ),
                SvgPicture.asset(
                  'assets/kid_section_icons/kid_coin_icon.svg',
                  height: 40,
                  width: 40,
                )
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          noJarWidget(
              assetName: 'assets/kid_section_icons/kid_add_jar_icon.svg')
        ],
      )),
    );
  }

  // no jar widget
  noJarWidget({required String assetName}) {
    return Center(child: SvgPicture.asset(assetName));
  }
}
