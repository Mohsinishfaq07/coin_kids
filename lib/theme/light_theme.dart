import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

   Color primaryTextColor=const Color(0xff015486);
  Color secondaryTextColor=const Color(0xff676666);
  Color whiteColorText=const Color(0xffFFFFFF);

  Color primaryButtonColor=const Color(0xffA421D9);

  Color disabledIconColor=const Color(0xff848484);
  Color activeIconColor=const Color(0xffA421D9);

  Color borderColor=const Color(0xffCBE5F4);
  static ThemeData getThemeData() {
    return ThemeData(
      primaryColor: Colors.purple,
      
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.openSans(
           color: const Color(0xff015486),
          fontSize: 24.0,
          fontWeight: FontWeight.w800
         ),
         bodyMedium: GoogleFonts.openSans(
           color: const Color(0xff676666),
          fontSize: 18.0,
          fontWeight: FontWeight.w400
         ),
         bodySmall:GoogleFonts.openSans(
           color: const Color(0xff676666),
          fontSize: 14.0,
          fontWeight: FontWeight.w400
         ),
         headlineMedium: GoogleFonts.openSans(
           color: const Color(0xff015486),
          fontSize: 18.0,
          fontWeight: FontWeight.w800
         ),
      
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        buttonColor: const Color(0xffA421D9),
      ),
      scaffoldBackgroundColor: Colors.blue[50], 
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white38,
        filled: true,
        hintStyle:GoogleFonts.openSans(
           color: const Color(0xff015486),
          fontSize: 14.0,
          fontWeight: FontWeight.w700
         ) ,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), 
        ),
      ),
    );
  }
}

