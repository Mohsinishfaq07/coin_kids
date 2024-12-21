import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class KidMyMoney extends StatelessWidget {
  const KidMyMoney({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            child: Image.asset('assets/avatar1.png'),
          ),
        ),
        title: Text(
          'Hello\nChild Name',
          style: GoogleFonts.openSans(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: Color(0xff015486)),
          textAlign: TextAlign.left,
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
