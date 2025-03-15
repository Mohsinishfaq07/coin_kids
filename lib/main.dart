import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/controller_bindings.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

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

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  SharedPreferencesHelper.init();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
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
        // First wrap with ResponsiveWrapper
        child = ResponsiveBreakpoints.builder(
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          child: child!,
        );

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
