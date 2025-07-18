import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_theme.dart';

// class ThemeClass{

//   Color primaryTextColor=const Color(0xff015486);
//   Color secondaryTextColor=const Color(0xff676666);
//   Color whiteColorText=const Color(0xffFFFFFF);

//   Color primaryButtonColor=const Color(0xffA421D9);

//   Color disabledIconColor=const Color(0xff848484);
//   Color activeIconColor=const Color(0xffA421D9);

//   TextStyle openSansStyle({
//     required Color textColor,
//       required double fontSize,
//       required FontWeight fontWeight
//   }){
//     return GoogleFonts.openSans(
//       color: textColor,
//       fontSize: fontSize,
//       fontWeight: fontWeight,
//     );

//   }

// }

class CustomThemeData {
  Color primaryTextColor = const Color(0xff015486);
  Color secondaryTextColor = const Color(0xff676666);
  Color whiteColorText = const Color(0xffFFFFFF);

  Color primaryButtonColor = const Color(0xffA421D9);

  Color disabledIconColor = const Color(0xff848484);
  Color activeIconColor = const Color(0xffA421D9);

  Color borderColor = const Color(0xffCBE5F4);

  static ThemeData getThemeData() {
    return ThemeData(
      colorSchemeSeed: const Color(0xffA421D9),
      // primaryColor: const Color(0xffA421D9),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.openSans(color: const Color(0xff015486), fontSize: 14.sp, fontWeight: MyFontWeight.semiBold.fontWeight),

        bodyMedium: GoogleFonts.openSans(color: AppColors.textPrimary, fontSize: 14.sp, fontWeight: MyFontWeight.regular.fontWeight,),

        bodySmall: GoogleFonts.openSans(color: AppColors.textPrimary, fontSize: 12.sp, fontWeight: MyFontWeight.regular.fontWeight,),
        headlineLarge: GoogleFonts.openSans(
          color: AppColors.textPrimary,
          fontSize: 24.sp,
          fontWeight: MyFontWeight.extraBold.fontWeight,
        ),
        headlineMedium: GoogleFonts.openSans(color: AppColors.textPrimary, fontSize: 18.sp, fontWeight:  MyFontWeight.extraBold.fontWeight),
        headlineSmall: GoogleFonts.openSans(color:  AppColors.textPrimary,fontSize: 14.sp,fontWeight: MyFontWeight.bold.fontWeight),
      ),
      buttonTheme: ButtonThemeData(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        buttonColor: const Color(0xffA421D9),
      ),

    //   static TextStyle appButton = TextStyle(
    //   fontFamily: 'OpenSans',
    //   fontSize: 14.h,
    //   fontWeight: MyFontWeight.extraBold.fontWeight,
    //   color: Colors.white,
    // );


      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Color(0xFFCAF0FF),
        elevation: 0.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white38,
        filled: true,
        hintStyle: GoogleFonts.openSans(color: const Color(0xff015486), fontSize: 14.0, fontWeight: FontWeight.w700),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey, // Border color when enabled
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.blue, // Border color when focused
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
