import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/notification_service.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/controllers/app_state_controller.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/login_screen.dart';
import 'package:get/get.dart';

class KidProfileController extends GetxController {
  final appState = Get.find<AppStateController>();
  final goalsService = Get.find<GoalService>();
  final Rx<KidProfileTabs> currentType = KidProfileTabs.Jars.obs;

  final NotificationService _notificationService = Get.find<NotificationService>();
  final notifications = <NotificationModel>[].obs;
  final isNotificationLoading = true.obs;
  final isGoalsLoading = true.obs;

  final RxList<GoalModel> goals = RxList();

  @override
  void onInit() {
    fetchNotifications();
    fetchGoals();
    super.onInit();
  }

  void fetchGoals() async {
    try {
      final kid = appState.currentKid.value;
      if (kid == null) {
            ToastUtil.showToast("Session Expired. Login Again");
            Get.offAll(() => LoginScreen());
            return;
          }

      final fetchedGoals = await goalsService.fetchUserGoals(appState.currentKid.value!.kidId);
      goals.clear();
      goals.assignAll(fetchedGoals);
    } catch (e) {
      print('Error fetching goals: $e');
      ToastUtil.showToast('Failed to fetch goals');
    } finally {
      isGoalsLoading.value = false;
    }
  }

  Future<void> fetchNotifications() async {
    try {
      final userId = Get.find<AuthService>().user.value?.uid;
      if (userId == null) return;

      final result = await _notificationService.getNotificationsPaginated(
        userId,
        lastDocument: null,
      );

      if (result.notifications.isEmpty) {
      } else {
        notifications.clear();
        notifications.addAll(result.notifications);
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      ToastUtil.showToast('Failed to load notifications');
    } finally {
      isNotificationLoading.value = false;
    }
  }

  void refresh() {
    fetchGoals();
    fetchNotifications();
  }
}
