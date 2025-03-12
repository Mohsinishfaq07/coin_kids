import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/notification_metadata.dart';
import '../../data/models/notification_model.dart';
import '../../data/models/goal_model.dart';

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

    // Sample data
    final List<Map<String, dynamic>> kidData = [
      {
        'name': 'Emily',
        'avatarUrl': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/avatars%2Femily.jpg',
        'id': 'kid_1'
      },
      {
        'name': 'Jack',
        'avatarUrl': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/avatars%2Fjack.jpg',
        'id': 'kid_2'
      },
      {
        'name': 'Sophie',
        'avatarUrl': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/avatars%2Fsophie.jpg',
        'id': 'kid_3'
      },
    ];

    final List<Map<String, dynamic>> goalData = [
      {
        'name': 'New Bicycle',
        'amount': 299.99,
        'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/goals%2Fbicycle.jpg',
      },
      {
        'name': 'PlayStation 5',
        'amount': 499.99,
        'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/goals%2Fps5.jpg',
      },
      {
        'name': 'Guitar',
        'amount': 199.99,
        'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/coinkids-app.appspot.com/o/goals%2Fguitar.jpg',
      },
    ];

    // Generate different types of notifications
    for (var i = 0; i < 50; i++) {
      final kidIndex = i % kidData.length;
      final goalIndex = i % goalData.length;
      final kid = kidData[kidIndex];
      final goal = goalData[goalIndex];
      final timestamp = now.subtract(Duration(hours: i * 2));

      NotificationMetadata? metadata;
      NotificationType type;
      String message;

      switch (i % 8) {
        case 0:
          // Goal Milestone (no actions)
          type = NotificationType.goal_milestone;
          metadata = GoalMilestoneMetadata(
            goalId: 'goal_$i',
            goalName: goal['name'],
            targetAmount: goal['amount'],
            currentAmount: goal['amount'] * 0.5,
            progressPercentage: 0.5,
          );
          message = '${kid['name']} reached 50% of their ${goal['name']} goal!';
          break;

        case 1:
          // Goal Completed (celebrate action)
          type = NotificationType.goal_completed;
          metadata = GoalCompletedMetadata(
            goalId: 'goal_$i',
            goalName: goal['name'],
            targetAmount: goal['amount'],
            startDate: timestamp.subtract(const Duration(days: 30)),
            completionDate: timestamp,
            imageUrl: goal['imageUrl'],
            kidAvatarUrl: kid['avatarUrl'],
          );
          message = '${kid['name']} completed their ${goal['name']} goal!';
          break;

        case 2:
          // Transaction Pending (approve/decline actions)
          type = NotificationType.transaction_pending;
          metadata = TransactionMetadata(
            transactionId: 'trans_$i',
            amount: 25.0,
            fromJarId: 'jar_1',
            toJarId: 'jar_2',
            note: 'Weekly allowance transfer',
            type: NotificationType.transaction_pending,
          );
          message = '${kid['name']} requested a money transfer';
          break;

        case 3:
          // Balance Added (no actions)
          type = NotificationType.balance_added;
          metadata = BalanceMetadata(
            jarId: 'jar_1',
            jarName: 'Savings Jar',
            amount: 50.0,
            newBalance: 150.0,
            type: NotificationType.balance_added,
          );
          message = 'Added money to ${kid['name']}\'s jar';
          break;

        case 4:
          // Wishlist Added (view action)
          type = NotificationType.wishlist_added;
          metadata = WishlistMetadata(
            itemId: 'item_$i',
            itemName: goal['name'],
            price: goal['amount'],
            imageUrl: goal['imageUrl'],
          );
          message = '${kid['name']} added ${goal['name']} to wishlist';
          break;

        default:
          // System Notification (no actions)
          type = NotificationType.system_notification;
          metadata = SystemNotificationMetadata(
            title: 'Welcome to CoinKids!',
            actionType: 'welcome',
            additionalData: {'kidName': kid['name']},
          );
          message = 'Start managing your children\'s finances';
      }

      final notification = NotificationModel(
        id: 'notification_$i',
        userId: userId,
        senderId: kid['id'],
        type: type,
        message: message,
        timestamp: timestamp,
        isRead: i % 3 == 0,
        metadata: metadata,
        imageUrl: type == NotificationType.wishlist_added ? goal['imageUrl'] : null,
      );

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