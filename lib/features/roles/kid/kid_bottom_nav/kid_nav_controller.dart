import 'package:coin_kids/features/roles/kid/kid_goals/kid_goals.dart';
import 'package:coin_kids/features/roles/kid/kid_my_money/kid_my_money.dart';
import 'package:coin_kids/features/roles/kid/kid_parent_zone/kid_parent_zone.dart';
import 'package:coin_kids/features/roles/kid/kid_shop/kid_shop.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class KidNavigationBarController extends GetxController {
  var currentIndex = 0.obs; // Reactive index to track selected tab

  final List<Widget> screens = [
    KidMyMoney(),
    KidGoals(),
    KidShop(),
    KidParentZone(),
  ];
}
