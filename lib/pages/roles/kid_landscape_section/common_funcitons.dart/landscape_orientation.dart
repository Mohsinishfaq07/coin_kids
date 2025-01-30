import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void landscapeOrientation() {
  // Set landscape orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  // Show the status bar
  _showStatusBar();

  // Set system UI overlay styles
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFCAF0FF), // Status bar color
      statusBarIconBrightness:
          Brightness.dark, // Dark icons for light background
      statusBarBrightness: Brightness.dark, // For iOS status bar
      systemNavigationBarColor:
          Colors.transparent, // Transparent navigation bar
    ),
  );
}

// Show the status bar briefly
void _showStatusBar() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

// Hide the status bar
