import 'package:flutter/material.dart';

class KidParentZone extends StatelessWidget {
  const KidParentZone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Text('KidParentZone'),
      )),
    );
  }
}
