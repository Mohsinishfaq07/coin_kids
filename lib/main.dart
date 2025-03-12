import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/controller_bindings.dart';
import 'package:coin_kids/presentation/screens/common/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import 'firebase_options.dart';

class ShowcaseManager {
  static final GlobalKey parentToKidNavShowcaseKey = GlobalKey();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferencesHelper.init();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  runApp(ShowCaseWidget(
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationAwareBuilder(
      builder: (context, orientation) {
        return GetMaterialApp(
          theme: CustomThemeData.getThemeData(),
          debugShowCheckedModeBanner: false,
          initialBinding: ControllerBindings(),
          home: SplashScreen(),
        );
      },
    );
  }
}

class OrientationAwareBuilder extends StatelessWidget {
  final Widget Function(BuildContext, Orientation) builder;

  const OrientationAwareBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        // Set design size based on orientation
        final designSize = orientation == Orientation.portrait ? const Size(360, 800) : const Size(800, 360);
        // final designSize = Size(360, 800);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: false,
          splitScreenMode: true,
          builder: (context, child) => builder(context, orientation),
        );
      },
    );
  }
}
