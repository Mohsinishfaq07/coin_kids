import 'package:flutter/material.dart';

class LoadingProgressDialogueWidget extends StatelessWidget {
  String title;
  LoadingProgressDialogueWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 10,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                const Center(
                  child: CircularProgressIndicator(),
                ),
                Text(title),

                // Close Button
              ],
            ),
          ),
        ));
  }
}
