import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/components/parent/empty_state.dart';
import 'package:coin_kids/presentation/components/parent/notification/notification_tile.dart';
import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationTabWidget extends GetView<KidProfileController> {
  const NotificationTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (controller.isNotificationLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return buildNotificationEmptyState(()async {

            await controller.analytics.buttonClicked(AnalyticsEventNames.goalsRefreshClicked, AnalyticsScreenNames.kidProfileScreen);

          });
        }

        return ListView.builder(
          itemCount: controller.notifications.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.notifications.length) {
              return TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.parentMessages);
                  },
                  child: Text("view all"));
            }
            final notification = controller.notifications[index];
            return buildNotificationTileCompact(controller, notification);
          },
        );
      }),
    );
  }
}
