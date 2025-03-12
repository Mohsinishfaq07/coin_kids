import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/components/parent/parent_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/empty_state.dart';
import 'package:coin_kids/presentation/components/parent/notification/notification_card.dart';
import 'package:coin_kids/presentation/controllers/parent/messages_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessagesScreen extends GetView<MessagesController> {
  const MessagesScreen({Key? key}) : super(key: key);

  Widget _buildNotificationsList() {
    return ListView.builder(
      itemCount: controller.notifications.length,
      itemBuilder: (context, index) {
        final notification = controller.notifications[index];
        return NotificationCard(
          notification: notification,
          onTap: () => controller.markAsRead(notification.id!),
          onActionPressed: (actionId) {
            controller.markAsRead(notification.id!);
            // controller.handleNotificationAction(notification, actionId);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ParentAppBar(
        showBackButton: false,
        title: 'Messages',
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.background),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SmartRefresher(
            controller: controller.refreshController,
            enablePullDown: true,
            enablePullUp: true,
            header: const WaterDropHeader(),
            footer: CustomFooter(
              builder: (context, mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = const Text("Pull up to load more");
                } else if (mode == LoadStatus.loading) {
                  body = const CircularProgressIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = const Text("Load Failed! Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = const Text("Release to load more");
                } else {
                  body = const Text("No more notifications");
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: controller.notifications.isEmpty 
              ? buildNotificationEmptyState(() {}) 
              : _buildNotificationsList(),
          );
        }),
      ),
    );
  }
}
