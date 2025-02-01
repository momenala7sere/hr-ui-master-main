import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;

class NotificationBadge extends StatelessWidget {
  final Stream<int> notificationStream;
  final Function(String) onNotificationSelected;

  const NotificationBadge({
    super.key,
    required this.notificationStream,
    required this.onNotificationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: notificationStream,
      builder: (context, snapshot) {
        int count = snapshot.data ?? 0;
        return custom_badge.Badge(
          badgeContent: Text(
            '$count',
            style: const TextStyle(color: Colors.white, fontSize: 12.0),
          ),
          badgeStyle: const custom_badge.BadgeStyle(badgeColor: Colors.red),
          position: custom_badge.BadgePosition.topEnd(top: 5, end: 5),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.notifications),
            onSelected: (value) => onNotificationSelected(value),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: '1',
                  child: ListTile(
                    leading: Icon(Icons.notification_important, color: Colors.red),
                    title: Text('New Task Assigned'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: '2',
                  child: ListTile(
                    leading: Icon(Icons.event, color: Colors.blue),
                    title: Text('Meeting Scheduled'),
                  ),
                ),
              ];
            },
          ),
        );
      },
    );
  }
}
