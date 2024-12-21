import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AddInSpending extends StatelessWidget {
  const AddInSpending({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'Spending Jar',
          style: GoogleFonts.openSans(
              fontSize: 18.0,
              fontWeight: FontWeight.w800,
              color: Color(0xff015486)),
        ),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 15),
              child: SvgPicture.asset(
                  'assets/kid_section_icons/kid_spending_jar.svg'),
            ),
          )
        ],
      )),
    );
  }
}
