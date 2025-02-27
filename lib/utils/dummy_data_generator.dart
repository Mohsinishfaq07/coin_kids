import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/notification_model.dart';
import '../data/models/goal_model.dart';

class DummyDataGenerator {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> insertDummyNotifications(String userId) async {
    try {
      final batch = _firestore.batch();
      final notifications = _generateDummyNotifications(userId);
      
      for (var notification in notifications) {
        final docRef = _firestore.collection('notifications').doc();
        batch.set(docRef, notification.toJson());
      }

      await batch.commit();
      print('Successfully inserted ${notifications.length} dummy notifications');
    } catch (e) {
      print('Error inserting dummy notifications: $e');
    }
  }

  static List<NotificationModel> _generateDummyNotifications(String userId) {
    final List<NotificationModel> notifications = [];
    final now = DateTime.now();

    // Sample kid names and goals
    final List<String> kidNames = ['Emily', 'Jack', 'Sophie', 'Lucas'];
    final List<String> goals = ['New Bicycle', 'PlayStation 5', 'Laptop', 'Guitar'];
    final List<double> amounts = [25.0, 50.0, 75.0, 100.0];

    // Generate different types of notifications
    for (var i = 0; i < 50; i++) {
      final kidName = kidNames[i % kidNames.length];
      final goal = goals[i % goals.length];
      final amount = amounts[i % amounts.length];
      final timestamp = now.subtract(Duration(hours: i * 2));

      NotificationModel notification;

      switch (i % 12) {
        case 0:
          notification = NotificationModel(
            userId: userId,
            senderId: 'kid_${i % 4}',
            type: NotificationType.goal_milestone,
            message: '$kidName reached 50% of their goal: $goal!',
            timestamp: timestamp,
            metadata: {'goalId': 'goal_$i', 'progress': 50},
          );
          break;

        case 1:
          notification = NotificationModel(
            userId: userId,
            senderId: 'kid_${i % 4}',
            type: NotificationType.goal_completed,
            message: '$kidName completed their goal: $goal!',
            timestamp: timestamp,
            metadata: {'goalId': 'goal_$i'},
          );
          break;

        case 2:
          notification = NotificationModel(
            userId: userId,
            senderId: 'kid_${i % 4}',
            type: NotificationType.transaction_pending,
            message: '$kidName requested €$amount for $goal',
            timestamp: timestamp,
            metadata: {'transactionId': 'trans_$i', 'amount': amount},
          );
          break;

        case 3:
          notification = NotificationModel(
            userId: userId,
            senderId: 'kid_${i % 4}',
            type: NotificationType.transaction_approved,
            message: 'You approved €$amount transfer to $kidName',
            timestamp: timestamp,
            metadata: {'transactionId': 'trans_$i', 'amount': amount},
          );
          break;

        case 4:
          notification = NotificationModel(
            userId: userId,
            senderId: 'kid_${i % 4}',
            type: NotificationType.transaction_rejected,
            message: 'You declined €$amount transfer to $kidName',
            timestamp: timestamp,
            metadata: {'transactionId': 'trans_$i', 'amount': amount},
          );
          break;

        case 5:
          notification = NotificationModel(
            userId: userId,
            senderId: 'kid_${i % 4}',
            type: NotificationType.reward_earned,
            message: '$kidName earned a new reward: "Weekend Movie"!',
            timestamp: timestamp,
            metadata: {'rewardId': 'reward_$i'},
          );
          break;

        case 6:
          notification = NotificationModel(
            userId: userId,
            senderId: 'kid_${i % 4}',
            type: NotificationType.task_completed,
            message: '$kidName completed task: "Clean Room"',
            timestamp: timestamp,
            metadata: {'taskId': 'task_$i'},
          );
          break;

        case 7:
          notification = NotificationModel(
            userId: userId,
            senderId: 'kid_${i % 4}',
            type: NotificationType.task_assigned,
            message: 'New task assigned to $kidName: "Homework"',
            timestamp: timestamp,
            metadata: {'taskId': 'task_$i'},
          );
          break;

        case 8:
          notification = NotificationModel(
            userId: userId,
            senderId: 'kid_${i % 4}',
            type: NotificationType.balance_low,
            message: '$kidName\'s balance is below €10',
            timestamp: timestamp,
            metadata: {'balance': 9.99},
          );
          break;

        case 9:
          notification = NotificationModel(
            userId: userId,
            senderId: 'kid_${i % 4}',
            type: NotificationType.balance_added,
            message: 'Added €$amount to $kidName\'s account',
            timestamp: timestamp,
            metadata: {'amount': amount},
          );
          break;

        case 10:
          notification = NotificationModel(
            userId: userId,
            senderId: 'kid_${i % 4}',
            type: NotificationType.wishlist_added,
            message: '$kidName added $goal to their wishlist',
            timestamp: timestamp,
            metadata: {'itemId': 'item_$i'},
          );
          break;

        default:
          notification = NotificationModel(
            userId: userId,
            senderId: 'system',
            type: NotificationType.system_notification,
            message: 'Welcome to CoinKids! Start managing your children\'s finances.',
            timestamp: timestamp,
          );
      }

      // Randomly mark some notifications as read
      if (i % 3 == 0) {
        notification = notification.copyWith(isRead: true);
      }

      notifications.add(notification);
    }

    return notifications;
  }

  static Future<void> insertDummyGoals(String userId) async {
    try {
      final batch = _firestore.batch();
      final goals = _generateDummyGoals(userId);
      
      for (var goal in goals) {
        final docRef = _firestore.collection('goals').doc();
        batch.set(docRef, goal.toJson());
      }

      await batch.commit();
      print('Successfully inserted ${goals.length} dummy goals');
    } catch (e) {
      print('Error inserting dummy goals: $e');
    }
  }

  static List<GoalModel> _generateDummyGoals(String userId) {
    final List<GoalModel> goals = [];
    final now = DateTime.now();

    final List<Map<String, dynamic>> goalTemplates = [
      {
        'title': 'New Bicycle',
        'photo': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/goals%2Fbicycle.jpg',
        'targetAmount': 299.99,
      },
      {
        'title': 'PlayStation 5',
        'photo': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/goals%2Fps5.jpg',
        'targetAmount': 499.99,
      },
      {
        'title': 'Laptop',
        'photo': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/goals%2Flaptop.jpg',
        'targetAmount': 799.99,
      },
      {
        'title': 'Guitar',
        'photo': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/goals%2Fguitar.jpg',
        'targetAmount': 199.99,
      },
      {
        'title': 'Art Supplies Set',
        'photo': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/goals%2Fart.jpg',
        'targetAmount': 149.99,
      },
      {
        'title': 'Science Kit',
        'photo': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/goals%2Fscience.jpg',
        'targetAmount': 89.99,
      },
      {
        'title': 'Nintendo Switch',
        'photo': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/goals%2Fswitch.jpg',
        'targetAmount': 299.99,
      },
      {
        'title': 'Basketball Kit',
        'photo': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/goals%2Fbasketball.jpg',
        'targetAmount': 79.99,
      }
    ];

    // Generate 8 goals with different statuses and progress
    for (var i = 0; i < 8; i++) {
      final template = goalTemplates[i];
      final targetAmount = template['targetAmount'] as double;
      final progress = i % 4 * 0.13; // 0%, 25%, 50%, 75% progress
      final savedAmount = targetAmount * progress;
      
      // Determine status based on progress and index
      GoalStatus status;
      DateTime? completedAt;
      
      if (i < 2) {
        status = GoalStatus.completed;
        completedAt = now.subtract(Duration(days: i * 10));
      } else if (i < 4) {
        status = GoalStatus.in_progress;
        completedAt = null;
      } else if (i < 6) {
        status = GoalStatus.pending;
        completedAt = null;
      } else {
        status = GoalStatus.cancelled;
        completedAt = now.subtract(Duration(days: i * 5));
      }

      final goal = GoalModel(
        userId: userId,
        title: template['title'],
        photo: template['photo'],
        targetAmount: targetAmount,
        savedAmount: savedAmount,
        status: status,
        createdAt: now.subtract(Duration(days: 90 - i * 10)),
        completedAt: completedAt,
      );

      goals.add(goal);
    }

    return goals;
  }

  // Helper method to insert both notifications and goals
  static Future<void> insertAllDummyData(String userId) async {
    // await insertDummyGoals(userId);
    // await insertDummyNotifications(userId);
    print('Successfully inserted all dummy data');
  }
} 