import 'package:coin_kids/bindings/controller_bindings.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/roles/kid/kid_jar_section/add_in_spending/add_in_spending.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'features/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //Make the status bar transparent
      statusBarIconBrightness:
          Brightness.dark, // Dark icons for light background
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: CustomThemeData.getThemeData(),
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBindings(),
      home: SplashScreen(),
    );
  }
}
