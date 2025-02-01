import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;

class MessageBadge extends StatelessWidget {
  final Stream<int> messageStream;
  final Function(String) onMessageSelected;

  const MessageBadge({
    super.key,
    required this.messageStream,
    required this.onMessageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: messageStream,
      builder: (context, snapshot) {
        int count = snapshot.data ?? 0;
        return custom_badge.Badge(
          badgeContent: Text(
            '$count',
            style: const TextStyle(color: Colors.white, fontSize: 12.0),
          ),
          badgeStyle: const custom_badge.BadgeStyle(badgeColor: Colors.blue),
          position: custom_badge.BadgePosition.topEnd(top: 5, end: 5),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.mail),
            onSelected: (value) => onMessageSelected(value),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: '1',
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.blue),
                    title: Text('New message from John'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: '2',
                  child: ListTile(
                    leading: Icon(Icons.group, color: Colors.green),
                    title: Text('Team message'),
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
