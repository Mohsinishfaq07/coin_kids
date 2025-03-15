import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/models/goal_model.dart';

class DummyDataGenerator {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> insertDummyGoals(String userId) async {
    try {
      final batch = _firestore.batch();
      final goals = _generateDummyGoals(userId);

      for (var goal in goals) {
        final docRef = _firestore.collection('goals').doc();
        batch.set(docRef, goal.toJson());
      }

      await batch.commit();
      Get.log('Successfully inserted ${goals.length} dummy goals');
    } catch (e) {
      Get.log('Error inserting dummy goals: $e');
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
        status = GoalStatus.inProgress;
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
    Get.log('Successfully inserted all dummy data');
  }
}
