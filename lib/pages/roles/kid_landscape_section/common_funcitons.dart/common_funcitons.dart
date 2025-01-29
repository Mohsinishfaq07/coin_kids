import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

landScapeOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
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

PortraitOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
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
