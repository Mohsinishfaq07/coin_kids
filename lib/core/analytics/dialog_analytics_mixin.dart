import 'package:coin_kids/presentation/controllers/common/analytics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin DialogAnalyticsMixin<T extends StatefulWidget> on State<T> {
  final AnalyticsController _analyticsController = Get.find<AnalyticsController>();
  late DateTime _dialogOpenTime;
  
  // Override this in your dialog to provide a name
  String get dialogName;
  
  @override
  void initState() {
    super.initState();
    _dialogOpenTime = DateTime.now();
    _analyticsController.trackDialogView(dialogName);
  }
  
  @override
  void dispose() {
    _analyticsController.trackDialogDismissal(dialogName, _dialogOpenTime);
    super.dispose();
  }
} 