import 'package:coin_kids/bindings/controller_bindings.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/landscape_orientation.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/common_funcitons.dart/portrait_orientation.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:showcaseview/showcaseview.dart';
import 'firebase_options.dart';
import 'pages/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Automatically generated options
  );
  controllerAndClassInitialization();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFCAF0FF),
      //Make the status bar transparent
      statusBarIconBrightness:
          Brightness.dark, // Dark icons for light background
      statusBarBrightness: Brightness.dark, //
      systemNavigationBarColor:
          Colors.transparent, // Black background for dark icons
    ),
  );

  runApp(ShowCaseWidget(
    builder: (context) => MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        PortraitOrientation();
      } else {
        landscapeOrientation();
      }
      return ScreenUtilInit(
          designSize: orientation == Orientation.portrait
              ? const Size(360, 800)
              : const Size(800, 360),
          minTextAdapt: true,
          splitScreenMode: true,
          child: GetMaterialApp(
            theme: CustomThemeData.getThemeData(),
            debugShowCheckedModeBanner: false,
            initialBinding: ControllerBindings(),
            home: SplashScreen(),
          ));
    });
  }
}
