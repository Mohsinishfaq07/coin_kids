import 'package:coin_kids/core/theme/light_theme.dart';
import 'package:coin_kids/core/translations/app_translations.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/controller_bindings.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:coin_kids/core/analytics/screen_tracking_observer.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Enable Firebase Analytics debug mode for development
  if (kDebugMode) {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    print('🔥 FIREBASE ANALYTICS: Debug mode enabled');
  }

  // Disable App Check for development
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode
        ? AppleProvider.debug
        : AppleProvider.appAttestWithDeviceCheckFallback,
  );

  SharedPreferencesHelper.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
   // DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
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
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
          child: GetMaterialApp(
            navigatorObservers: [
              observer,
              ScreenTrackingObserver(),
            ],
            smartManagement: SmartManagement.keepFactory,
             //theme: AppColors();
            theme: CustomThemeData.getThemeData(),
            debugShowCheckedModeBanner: false,
            useInheritedMediaQuery: true,
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
            translations: AppTranslations(),
            fallbackLocale: const Locale('en', 'US'),
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('es', 'ES'),
              Locale('ar', 'SA'),
              Locale('fr', 'FR'),
              Locale('de', 'DE'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: Routes.splash,
            getPages: AppPages.pages,
            home: child,
          ),
        );
      },
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
        final designSize = orientation == Orientation.portrait
            ? const Size(360, 800)
            : const Size(800, 360);

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
