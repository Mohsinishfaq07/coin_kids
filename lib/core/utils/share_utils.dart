import 'dart:io' show Platform;

import 'package:coin_kids/core/constants/constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class ShareUtils {
  static const String supportEmail = "support@coinkids.com";

  static Future<void> shareApp() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String platform = Platform.isAndroid ? "Play Store" : "App Store";
    final String storeLink =
        Platform.isAndroid ? "https://play.google.com/store/apps/details?id=${packageInfo.packageName}" : "https://apps.apple.com/app/idYOUR_APP_ID"; //TODO: Replace with your App Store ID

    final String shareText = '''
🎯 Discover CoinKids - The Ultimate Financial Education App for Children! 

Help your kids learn essential money management skills through fun and interactive experiences. From saving to smart spending, CoinKids makes financial education engaging and rewarding.

Download now from $platform:
$storeLink
''';

    await Share.share(shareText);
  }

  static Future<void> openLink(destination) async {
    final Uri url = Uri.parse(destination);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch privacy policy');
    }
  }

  static Future<void> openPrivacyPolicy() async {
    final Uri url = Uri.parse(privacyPolicy);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch privacy policy');
    }
  }

  static Future<void> sendFeedback({String additionalText = ""}) async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceData = '';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceData = '''
Device: ${androidInfo.brand} ${androidInfo.model}
Android Version: ${androidInfo.version.release}
SDK: ${androidInfo.version.sdkInt}''';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceData = '''
Device: ${iosInfo.name} ${iosInfo.model}
iOS Version: ${iosInfo.systemVersion}''';
      }

      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final appInfo = '''
App Version: ${packageInfo.version}
Build Number: ${packageInfo.buildNumber}''';

      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: supportEmail,
        queryParameters: {
          'subject': 'CoinKids App Feedback',
          'body': '''


-----------------
Device Information:
$deviceData

App Information:
$appInfo

-----------------
FeedBack
$additionalText
'''
        },
      );

      if (!await launchUrl(emailLaunchUri)) {
        throw Exception('Could not launch email app');
      }
    } catch (e) {
      Get.log('Error sending feedback: $e');
      rethrow;
    }
  }
}
