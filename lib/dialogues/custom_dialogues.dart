import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingProgressDialogueWidget extends StatelessWidget {
  String title;
  LoadingProgressDialogueWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: Container(
            height: 200, // Square height
            width: 200, // Square width
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.purple,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black, // Ensure correct text color
                              fontWeight: FontWeight.bold,
                            ) ??
                        TextStyle(
                            color: Colors
                                .black), // Fallback if no bodyText2 is defined
                    textAlign: TextAlign.center,
                  ),

                  // Close Button
                ],
              ),
            ),
          ),
        ));
  }
}

class KidsZoneDialog extends StatelessWidget {
  final String purpleBgPath;
  final String coinIconPath;
  final String closeIconPath;
  final String greenButtonBgPath;
  final String tickIconPath;
  final String label;
  final String subLabel;

  const KidsZoneDialog({
    Key? key,
    required this.purpleBgPath,
    required this.coinIconPath,
    required this.closeIconPath,
    required this.greenButtonBgPath,
    required this.tickIconPath,
    required this.label,
    required this.subLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            purpleBgPath,
            fit: BoxFit.fill,
            width: 300,
            height: 150,
          ),
          Positioned(
            top: -30,
            left: 110,
            child: SvgPicture.asset(
              coinIconPath,
              width: 60,
              height: 60,
            ),
          ),
          Positioned(
            top: -1,
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                closeIconPath,
                width: 30,
                height: 30,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 40,
            right: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  subLabel,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -20,
            left: 100,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    greenButtonBgPath,
                    width: 80,
                    height: 40,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        tickIconPath,
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to show the dialog
void showKidsZoneDialog(
  BuildContext context, {
  required String purpleBgPath,
  required String coinIconPath,
  required String closeIconPath,
  required String greenButtonBgPath,
  required String tickIconPath,
  required String label,
  required String subLabel,
}) {
  showDialog(
    context: context,
    builder: (context) => KidsZoneDialog(
      purpleBgPath: purpleBgPath,
      coinIconPath: coinIconPath,
      closeIconPath: closeIconPath,
      greenButtonBgPath: greenButtonBgPath,
      tickIconPath: tickIconPath,
      label: label,
      subLabel: subLabel,
    ),
  );
}
