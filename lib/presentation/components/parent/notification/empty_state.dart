import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildNotificationEmptyState(controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.notifications_none, size: 48.sp, color: Colors.grey),
      SizedBox(height: 16.h),
      Text(
        'No notifications yet',
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey,
        ),
      ),
      TextButton(
        onPressed: () => controller.onRefresh(),
        child: Text('Refresh'),
      ),
    ],
  );
}

Widget buildGoalsEmptyState(controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.notifications_none, size: 48.sp, color: Colors.grey),
      SizedBox(height: 16.h),
      Text(
        'No Goals yet',
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey,
        ),
      ),
      TextButton(
        onPressed: () => controller.onRefresh(),
        child: Text('Refresh'),
      ),
    ],
  );
}
