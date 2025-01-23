import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

setOrientationAndStatusBar() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
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
