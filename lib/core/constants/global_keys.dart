import 'package:flutter/material.dart';

/// A centralized class to store all GlobalKeys used across the application.
/// This helps maintain consistency and avoid duplicate key declarations.
class GlobalKeys {
  // Market Screen Keys
  static final GlobalKey productKey = GlobalKey();
  static final GlobalKey wishlistKey = GlobalKey();
  static GlobalKey firstFavoriteKey = GlobalKey();

  // Money Drag and Drop Screen Keys
  static final GlobalKey containerKey = GlobalKey();
  static final GlobalKey moneyKey = GlobalKey();
  static final GlobalKey coinButtonKey = GlobalKey();

  // Tutorial Keys
  static final GlobalKey totalMoneyCardKey = GlobalKey();
  static final GlobalKey goalsNavKey = GlobalKey();

  // Transfer Screen Keys
  static final GlobalKey spendToSaveKey = GlobalKey();
  static final GlobalKey saveToSpendKey = GlobalKey();

  /// Key for the Goals label in the navigation bar
  static final goalsLabelKey = GlobalKey();
  static final GlobalKey sliderKey = GlobalKey();
// create goal
  static final GlobalKey okButtonKey = GlobalKey();
  //kid home screen on transfer button
  static final GlobalKey transferButtonKey = GlobalKey();




} 