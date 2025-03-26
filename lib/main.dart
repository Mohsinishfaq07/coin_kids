import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/controller_bindings.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Disable App Check for development
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttestWithDeviceCheckFallback,
  );

  SharedPreferencesHelper.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
   // DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => MyApp(), // Wrap your app
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      smartManagement: SmartManagement.keepFactory,
      theme: CustomThemeData.getThemeData(),
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: (context, child) {
        // Then apply DevicePreview
        final devicePreviewChild = DevicePreview.appBuilder(context, child);

        return OrientationAwareBuilder(
          builder: (context, orientation) {
            return devicePreviewChild;
          },
        );
      },
      initialBinding: ControllerBindings(),
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
    );
  }
}

class OrientationAwareBuilder extends StatelessWidget {
  final Widget Function(BuildContext, Orientation) builder;

  const OrientationAwareBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final designSize = orientation == Orientation.portrait ? const Size(360, 800) : const Size(800, 360);

        return ScreenUtilInit(
          designSize: designSize,
          ensureScreenSize: false,
          minTextAdapt: false,
          splitScreenMode: false,
          builder: (context, child) => builder(context, orientation),
        );
      },
    );
  }
}
