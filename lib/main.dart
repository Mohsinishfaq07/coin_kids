import 'package:coin_kids/bindings/controller_bindings.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'pages/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  controllerAndClassInitialization();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //Make the status bar transparent
      statusBarIconBrightness:
          Brightness.dark, // Dark icons for light background
      statusBarBrightness: Brightness.dark, //
      systemNavigationBarColor:
          Colors.transparent, // Black background for dark icons
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        theme: CustomThemeData.getThemeData(),
        debugShowCheckedModeBanner: false,
        initialBinding: ControllerBindings(),
        home: SplashScreen(),
      ),
    );
  }
}
