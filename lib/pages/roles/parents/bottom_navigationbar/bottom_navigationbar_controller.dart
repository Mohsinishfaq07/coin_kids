import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/messages_screen/messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigationbarController extends GetxController {
  var currentIndex = 0.obs; // Reactive index to track selected tab

  final List<Widget> screens = [
    ParentsHomeScreen(),
    MessagesScreen(),
    ShopScreen(),
    KidZoneScreen(),
  ];
}

// class MessagesScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Messages'),
//       ),
//       body: Center(
//         child: Text(
//           'Welcome to Messages Screen',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: Center(
        child: Text(
          'Welcome to Shop Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class KidZoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kid Zone'),
      ),
      body: Center(
        child: Text(
          'Welcome to Kid Zone Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
