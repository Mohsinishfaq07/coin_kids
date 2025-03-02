import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/presentation/components/parent/custom_app_bar.dart';
import 'package:coin_kids/presentation/components/parent/notification/empty_state.dart';
import 'package:coin_kids/presentation/components/parent/notification/notification_tile.dart';
import 'package:coin_kids/presentation/controllers/parent/messages_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessagesScreen extends GetView<MessagesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: false,
        title: 'Messages',
        actions: [
          Obx(() {
            if (controller.selectedNotifications.isNotEmpty) {
              return Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.done_all),
                    onPressed: () => controller.markSelectedAsRead(true),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _showDeleteSelectedDialog(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => controller.clearSelection(),
                  ),
                ],
              );
            }
            return IconButton(
              icon: Icon(Icons.done_all),
              onPressed: () => controller.markAllAsRead(),
            );
          }),
        ],
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
                ? buildNotificationEmptyState(controller)
                : ListView.builder(
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return buildNotificationTile(controller, notification);
                    },
                  ),
          );
        }),
      ),
    );
  }

  Future<void> _showDeleteSelectedDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Selected Notifications'),
        content: Text('Are you sure you want to delete selected notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteSelected();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Future<void> _showDeleteAllDialog(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Delete All Notifications'),
  //       content: Text('Are you sure you want to delete all notifications?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             controller.deleteAllNotifications();
  //           },
  //           child: Text('Delete', style: TextStyle(color: Colors.red)),
  //         ),
  //       ],
  //     ),
  //   );
  // }


}
