import 'package:flutter/material.dart';

class CardData {
  final String title;
  final IconData icon;
  final Color color;
  final String routeName; // Use routeName instead of widget-based route

  CardData({
    required this.title,
    required this.icon,
    required this.color,
    required this.routeName,
  });

  /// Factory method to create CardData from API or dynamic sources
  factory CardData.fromMap(Map<String, dynamic> map) {
    return CardData(
      title: map['menuName'] ?? 'Untitled',
      icon: _getIconForTitle(map['menuName'] ?? ''),
      color: const Color(0xFFCE5E52), // Customize color if needed
      routeName: _getRouteNameForTitle(map['menuName'] ?? ''), // Map route dynamically
    );
  }

  /// Determine the icon based on the card title
  static IconData _getIconForTitle(String title) {
    if (title.contains('Vacation')) return Icons.beach_access;
    if (title.contains('Leave') && title.contains('Personal')) return Icons.access_time; // Personal Leave
    if (title.contains('Leave') && title.contains('Sick')) return Icons.local_hospital; // Sick Leave
    if (title.contains('History')) return Icons.history;
    if (title.contains('HR')) return Icons.group;
    if (title.contains('Request')) return Icons.assignment;
    if (title.contains('Track')) return Icons.pin_drop; // Track Request
    return Icons.help_outline; // Default icon
  }

  /// Map the card title to a predefined route name
  static String _getRouteNameForTitle(String title) {
    if (title.contains('Vacation')) return '/vacation-request';
    if (title.contains('Leave') && title.contains('Personal')) return '/personal-leave-request';
    if (title.contains('Leave') && title.contains('Sick')) return '/sick-leave-request';
    if (title.contains('History') && title.contains('Vacation')) return '/vacation-history';
    if (title.contains('History') && title.contains('Leave')) return '/leaves-history';
    if (title.contains('HR')) return '/Hr-request';
    if (title.contains('Request')) return '/track-my-request';
    if (title.contains('Track')) return '/track-my-request';
    return '/HomePage'; // Default fallback route
  }
}
