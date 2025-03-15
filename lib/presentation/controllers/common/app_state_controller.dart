import 'dart:async';

import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/models/parent_model.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppStateController extends GetxController {
  final _kidService = Get.find<KidService>();
  final _authService = Get.find<AuthService>();
  final _parentService = Get.find<ParentService>();

  // Single kid observable
  final currentKid = Rxn<KidModel>();
  final hasKid = false.obs;

  // Parent related observables
  final currentParent = Rxn<ParentModel>();
  final isParentLoading = false.obs;

  // Stream subscriptions
  StreamSubscription? _kidSubscription;
  StreamSubscription? _parentSubscription;
  StreamSubscription? _authSubscription;

  final orientation = Orientation.portrait.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _authSubscription = _authService.user.listen((user) {
      Get.log("AppStateController: Auth state changed - User: ${user?.uid}");
      if (user != null) {
        _initStreams();
      } else {
        _cancelStreams();
        // Clear current data
        currentKid.value = null;
        hasKid.value = false;
        currentParent.value = null;
      }
    });
  }

  void _initStreams() {
    final userId = _authService.user.value?.uid;
    if (userId == null) {
      Get.log("AppStateController: No user ID available");
      return;
    }

    Get.log("AppStateController: Initializing streams for user: $userId");

    // Subscribe to single kid stream
    _kidSubscription = _kidService.streamKidByParentId(userId).listen((kid) {
      Get.log("AppStateController: Received kid data: ${kid?.name}");
      currentKid.value = kid;
      hasKid.value = kid != null;
    });

    // Subscribe to parent data stream
    isParentLoading.value = true;
    _parentSubscription?.cancel();
    _parentSubscription = _parentService.streamParentData().listen(
      (parent) {
        Get.log("AppStateController: Received parent data: $parent");
        currentParent.value = parent;
        isParentLoading.value = false;
      },
      onError: (error) {
        Get.log("AppStateController: Parent stream error: $error");
        isParentLoading.value = false;
      },
      onDone: () {
        Get.log("AppStateController: Parent stream completed");
        isParentLoading.value = false;
      },
    );
  }

  // Refresh streams (useful after login/logout)
  void refreshStreams() {
    Get.log("AppStateController: Refreshing streams");
    _cancelStreams();
    _initStreams();
  }

  // Cancel all streams
  void _cancelStreams() {
    Get.log("AppStateController: Cancelling streams");
    _kidSubscription?.cancel();
    _parentSubscription?.cancel();
  }

  void updateOrientation(Orientation newOrientation) {
    if (orientation.value != newOrientation) {
      orientation.value = newOrientation;
    }
  }

  @override
  void onClose() {
    Get.log("AppStateController: Disposing controller");
    _cancelStreams();
    _authSubscription?.cancel();
    super.onClose();
  }
}
