import 'package:coin_kids/core/utils/portrait_orientation.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/controller_bindings.dart';
import 'package:coin_kids/core/utils/landscape_orientation.dart';
import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/presentation/screens/common/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:showcaseview/showcaseview.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferencesHelper.init();

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
    builder: (context) => const MyApp(),
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
