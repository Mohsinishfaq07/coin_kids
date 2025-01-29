import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JarWithoutMoneyTitle extends StatelessWidget {
  final String JarTitle;
  final double amount;
  JarWithoutMoneyTitle({
    required this.JarTitle,
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/Jar_without_money.png", // Replace with your filled jar asset
          height: 100.h,
          width: 140.w,
        ),
        Positioned(
          bottom: 36.h,
          left: 30.w,
          child: Center(
              child: Text(
            JarTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF015486),
              fontSize: 18.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w800,
              height: 2.44,
            ),
          )),
        ),
        // SizedBox(height: 10.h),
        Positioned(
            bottom: 0.h,
            left: 30.w,
            child: Center(
              child: Container(
                width: 90.w,
                height: 16.h,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.53.w, color: Color(0xFF015486)),
                    borderRadius: BorderRadius.circular(51.33.r),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F6169D3),
                      blurRadius: 2.60,
                      offset: Offset(-1.30, 1.95),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '\$$amount',
                            style: TextStyle(
                              color: Color(0xFF015486),
                              fontSize: 15.83.sp,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: '€',
                            style: TextStyle(
                              color: Color(0xFF015486),
                              fontSize: 15.83.sp,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
