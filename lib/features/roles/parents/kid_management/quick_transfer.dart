import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/roles/parents/kid_management/kid_profile_management_page.dart';
import 'package:flutter/material.dart';

class QuickTransferPage extends StatelessWidget {
  const QuickTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Quick Transfer"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //   childGeneralDetailWidget(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
