import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void lockPortraitMode() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

void lockLandscapeMode() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
}
