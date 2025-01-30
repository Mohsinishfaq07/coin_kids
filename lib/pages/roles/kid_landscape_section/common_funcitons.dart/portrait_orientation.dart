import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

PortraitOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top, // Show status bar
    SystemUiOverlay.bottom, // Show navigation bar
  ]);

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
}
