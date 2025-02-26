import 'package:flutter/material.dart';

PreferredSizeWidget kidsAppBar(
    {required Widget leadingWidget, List<Widget>? actionWidgets}) {
  List<Widget> actions =
      (actionWidgets != null && actionWidgets.isNotEmpty) ? actionWidgets : [];
  return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0.0,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: leadingWidget,
      actions: actions);
}
