import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void showToast(String message, {Color? color}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: color ?? AppColors.colorPrimary,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showExceptionToast(dynamic message) {
    final error = message.toString().substring(11);
    Fluttertoast.showToast(
      msg: error,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.notificationCritical,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
