import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:get/get.dart';

class BaseService extends GetxService {
  static const int timeoutDuration = 15; // 15 seconds timeout

  Future<T> withTimeout<T>(Future<T> Function() operation, {String? customMessage}) async {
    // Create a completer to handle the operation
    final completer = Completer<T>();
    
    // Create timer for timeout
    final timer = Timer(const Duration(seconds: timeoutDuration), () {
      if (!completer.isCompleted) {
        completer.completeError(TimeoutException('Operation timed out'));
      }
    });

    try {
      // Start the operation
      final result = await operation();
      
      // If operation completes before timeout, return result
      if (!completer.isCompleted) {
        completer.complete(result);
      }
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    } finally {
      timer.cancel();
    }

    try {
      return await completer.future;
    } on TimeoutException {
      ToastUtil.showToast(
        customMessage ?? 'Slow or no internet connection. Please try again.',
      );
      throw TimeoutException('Operation timed out');
    }
  }

  Stream<T> withStreamTimeout<T>(Stream<T> stream) {
    StreamController<T>? controller;
    StreamSubscription? subscription;
    Timer? timer;

    controller = StreamController<T>(
      onListen: () {
        // Start timeout timer
        timer = Timer(const Duration(seconds: timeoutDuration), () {
          ToastUtil.showToast('Slow or no internet connection. Please try again.');
          subscription?.cancel();
          if (!controller!.isClosed) {
            controller.addError(TimeoutException('Stream operation timed out'));
            controller.close();
          }
        });

        // Listen to the original stream
        subscription = stream.listen(
          (data) {
            if (!controller!.isClosed) {
              controller.add(data);
              // Reset timer on each data event
              timer?.cancel();
              timer = Timer(const Duration(seconds: timeoutDuration), () {
                subscription?.cancel();
                if (!controller!.isClosed) {
                  controller.addError(TimeoutException('Stream operation timed out'));
                  controller.close();
                }
              });
            }
          },
          onError: (error) {
            if (!controller!.isClosed) {
              controller.addError(error);
            }
          },
          onDone: () {
            timer?.cancel();
            if (!controller!.isClosed) {
              controller.close();
            }
          },
        );
      },
      onCancel: () {
        timer?.cancel();
        subscription?.cancel();
      },
    );

    return controller.stream;
  }

  // Helper method to cancel Firestore operations
  Future<void> cancelFirestoreOperation(Future<void> operation) async {
    try {
      // Create a completer to handle the operation
      final completer = Completer<void>();
      
      // Create timer for timeout
      final timer = Timer(const Duration(seconds: timeoutDuration), () {
        if (!completer.isCompleted) {
          // Force close any active connections
          FirebaseFirestore.instance.terminate();
          // Reinitialize Firestore for future operations
          FirebaseFirestore.instance.clearPersistence();
          
          completer.completeError(TimeoutException('Operation timed out'));
        }
      });

      try {
        await operation;
        if (!completer.isCompleted) {
          completer.complete();
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      } finally {
        timer.cancel();
      }

      await completer.future;
    } on TimeoutException {
      ToastUtil.showToast('Operation cancelled due to slow connection');
      throw TimeoutException('Operation cancelled');
    }
  }
} 