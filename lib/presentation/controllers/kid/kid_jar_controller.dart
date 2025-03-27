import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class KidJarController extends GetxController {
  final amountTextFieldKey = GlobalKey(debugLabel: 'AmountTextFieldKey');
  final colorGridKey = GlobalKey(debugLabel: 'SelectJarColor');
  var selectedColorIndex = (-1).obs; // Default to no selection
  final jarKey = GlobalKey(debugLabel: 'jarKey');



  @override
  void onClose() {
    amountTextFieldKey.currentState?.dispose();
    colorGridKey.currentState?.dispose();
    jarKey.currentState?.dispose();

    super.onClose();
  }


  final List<Color> colors = [
    const Color(0xFFFF6060),
    const Color(0xFF8F60FF),
    const Color(0xFFE360FF),
    const Color(0xFFFEC61C),
    const Color(0xFF434343),
    const Color(0xFFFF9500),
    const Color(0xFF4CAF50),
    const Color(0xFF3F89FC),
    const Color(0xFF3FD9FC),
    const Color(0xFF4BD1C5),
    const Color(0xFFFF60C4),
    const Color(0xFF3F51FC),
  ];
}
