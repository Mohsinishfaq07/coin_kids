import 'package:coin_kids/presentation/dialogs/parent/app_parent_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtils {
  static OverlayEntry? _currentDialog;

  static void showDialog({
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    if (Get.context == null) return;

    _currentDialog = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Barrier
          GestureDetector(
            onTap: barrierDismissible ? dismissDialog : null,
            child: Container(
              color: Colors.black54,
            ),
          ),
          // Dialog
          Center(
            child: Material(
              color: Colors.transparent,
              child: dialog,
            ),
          ),
        ],
      ),
    );

    // Show dialog using Navigator's overlay
    if (_currentDialog != null) {
      Navigator.of(Get.context!).overlay?.insert(_currentDialog!);
    }
  }

  static void dismissDialog() {
    if (_currentDialog != null) {
      _currentDialog!.remove();
      _currentDialog = null;
    }
  }
}

// Show dialog
void showLoadingDialog() {
  DialogUtils.showDialog(
    dialog: const AppParentDialog(
      title: "Loading...",
      message: "Please wait while we process your request",
      buttons: [], // No buttons for loading dialog
    ),
    barrierDismissible: false, // Prevent dismissal by tapping outside
  );
}

// Dismiss dialog programmatically
void hideLoadingDialog() {
  DialogUtils.dismissDialog();
}

// // Example usage in a controller
// class SomeController extends GetxController {
//   Future<void> someAsyncOperation() async {
//     try {
//       showLoadingDialog();

//       // Do some async work
//       await Future.delayed(const Duration(seconds: 2));

//       // Show success dialog
//       DialogUtils.showDialog(
//         dialog: CustomDialog(
//           iconPath: "assets/success.svg",
//           title: "Success",
//           message: "Operation completed successfully",
//           buttons: [
//             DialogButton(
//               text: "OK",
//               onPressed: () => DialogUtils.dismissDialog(),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       // Show error dialog
//       DialogUtils.showDialog(
//         dialog: CustomDialog(
//           iconPath: "assets/error.svg",
//           title: "Error",
//           message: e.toString(),
//           buttons: [
//             DialogButton(
//               text: "OK",
//               onPressed: () => DialogUtils.dismissDialog(),
//             ),
//           ],
//         ),
//       );
//     } finally {
//       hideLoadingDialog();
//     }
//   }
// }
