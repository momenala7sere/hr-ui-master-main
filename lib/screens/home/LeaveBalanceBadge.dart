import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;

class LeaveBalanceBadge extends StatelessWidget {
  final int leaveBalance;

  const LeaveBalanceBadge({super.key, required this.leaveBalance});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Leave Balance: $leaveBalance',
      child: custom_badge.Badge(
        badgeContent: Text(
          '$leaveBalance',
          style: const TextStyle(color: Colors.white, fontSize: 12.0),
        ),
        badgeStyle: const custom_badge.BadgeStyle(badgeColor: Colors.red),
        position: custom_badge.BadgePosition.topEnd(top: 5, end: 5),
        child: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            // Handle leave balance click
          },
        ),
      ),
    );
  }
}
