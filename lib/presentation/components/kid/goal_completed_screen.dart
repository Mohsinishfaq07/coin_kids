import 'package:flutter/material.dart';

class TimelineScreen extends StatelessWidget {
  final List<TimelineEvent> events = [
    TimelineEvent(
      date: "07/04",
      title: "Congratulations!",
      subtitle: "You completed PlayStation 5",
      icon: Icons.emoji_events,
      color: Colors.orange,
    ),
    TimelineEvent(
      date: "08/04",
      title: "Mom ordered it for you",
      avatar: "assets/mom_avatar.png", // Use a network image or asset
      label: "MOM",
      labelColor: Colors.pink,
    ),
    TimelineEvent(
      date: "10/04",
      title: "Expected delivery",
      icon: Icons.local_shipping,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(title: Text("Timeline")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return TimelineTile(
              event: events[index],
              isFirst: index == 0,
              isLast: index == events.length - 1);
        },
      ),
    );
  }
}

class TimelineTile extends StatelessWidget {
  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;

  const TimelineTile(
      {required this.event, required this.isFirst, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(height: 20, width: 3, color: Colors.grey), // Top line
            event.avatar != null
                ? CircleAvatar(
                    radius: 20, backgroundImage: AssetImage(event.avatar!))
                : CircleAvatar(
                    radius: 20,
                    backgroundColor: event.color,
                    child: Icon(event.icon, color: Colors.white)),
            if (!isLast)
              Container(
                  height: 40, width: 3, color: Colors.grey), // Bottom line
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.date,
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              SizedBox(height: 5),
              Text(event.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (event.subtitle != null)
                Text(event.subtitle!,
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
              if (event.label != null)
                Container(
                  margin: EdgeInsets.only(top: 4),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: event.labelColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(event.label!,
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class TimelineEvent {
  final String date;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color color;
  final String? avatar;
  final String? label;
  final Color labelColor;

  TimelineEvent({
    required this.date,
    required this.title,
    this.subtitle,
    this.icon,
    this.color = Colors.blue,
    this.avatar,
    this.label,
    this.labelColor = Colors.transparent,
  });
}
