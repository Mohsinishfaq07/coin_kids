import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/roles/parents/bottom_navigationbar/messages_screen/messages_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatelessWidget {
  final MessagesController controller = Get.put(MessagesController());

  MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showBackButton: false,
          title: 'Messages',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              CustomCard(
                avatarImage: "assets/avatar3.png",
                title: "Saving Goals Completed!",
                subtitle: "Today at 9:42 AM",
                icon: Icons.import_contacts,
                iconBgColor: Colors.pink,
                titleColor: Colors.blue.shade900,
                subtitleColor: Colors.grey,
                actionText: "See details",
                onActionTap: () {
                  // Define your action here
                  debugPrint("See details clicked!");
                },
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey.shade200,
                            child: Image.asset(
                              'assets/avatar3.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "helo testing 123", // Static for now; customize further if needed.

                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                                 
                                width: 170,
                                text: "Decline",
                                 
                                onPressed: () {}),
                            CustomButton(
                                width: 170,
                                text: "Approve",
                                onPressed: () {},
                               ),
                          ],
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Today at 9:42 AM",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              CustomCard(
                avatarImage: "assets/avatar3.png",
                title: "James Goals Completed!",
                subtitle: "Today at 9:42 AM",
                icon: Icons.import_contacts,
                iconBgColor: Colors.pink,
                titleColor: Colors.blue.shade900,
                subtitleColor: Colors.grey,
                actionText: "See details",
                onActionTap: () {
                  // Define your action here
                  debugPrint("See details clicked!");
                },
              ),
            ],
          ),
        ));
  }
}

class CustomCard extends StatelessWidget {
  final String avatarImage;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBgColor;
  final Color titleColor;
  final Color subtitleColor;
  final String actionText;
  final VoidCallback onActionTap;

  const CustomCard({
    Key? key,
    required this.avatarImage,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.actionText,
    required this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Avatar Section
            Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  child: Image.asset(
                    avatarImage,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "", // Static for now; customize further if needed.
                ),
              ],
            ),

            // Main Text Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Icon and Action Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onActionTap,
                  child: Text(
                    actionText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.purple,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
