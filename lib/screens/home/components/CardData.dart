import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardData {
  final String title;
  final IconData icon;
  final Color color;
  final String routeName;
  final String category; // Field for grouping, if needed

  CardData({
    required this.title,
    required this.icon,
    required this.color,
    required this.routeName,
    this.category = '',
  });

  /// Creates a CardData instance from a Map (for example, from an API response).
  factory CardData.fromMap(Map<String, dynamic> map) {
    final menuName = map['menuName'] as String? ?? 'Untitled';
    final iconString = map['icon'] as String? ?? '';
    return CardData(
      title: menuName,
      icon: _mapApiIconToFaIcon(iconString, menuName),
      // Set the color for all cards to Color(0xFFCE5E52)
      color: const Color(0xFFCE5E52),
      routeName: _getRouteNameForTitle(menuName),
      category: map['category'] as String? ?? '',
    );
  }

  /// Maps the API icon string to a FontAwesome [IconData] using a dictionary.
  static IconData _mapApiIconToFaIcon(String iconString, String title) {
    iconString = iconString.trim();

    // If the API does not provide an icon, use a fallback based on the title.
    if (iconString.isEmpty) return _getIconForTitle(title);

    // Split the string by whitespace and look for a token starting with "fa-".
    final parts = iconString.split(' ');
    String? iconName;
    for (final part in parts) {
      if (part.startsWith('fa-')) {
        iconName = part.substring(3); // Remove the 'fa-' prefix
        break;
      }
    }
    // If no icon name is found, fallback to the title-based icon.
    if (iconName == null) return _getIconForTitle(title);

    // Mapping dictionary from icon names to FontAwesomeIcons.
    final iconMap = <String, IconData>{
      'user-tag': FontAwesomeIcons.userTag,
      'user-plus': FontAwesomeIcons.userPlus,
      'user-clock': FontAwesomeIcons.userClock,
      'group': FontAwesomeIcons.users,
      'business-time': FontAwesomeIcons.businessTime,
      'shopping-cart': FontAwesomeIcons.cartShopping,
      'history': FontAwesomeIcons.clockRotateLeft,
      'tasks': FontAwesomeIcons.listCheck,
      'route': FontAwesomeIcons.route,
      'laptop-house': FontAwesomeIcons.houseLaptop,
      'door-open': FontAwesomeIcons.doorOpen,
      'file-alt': FontAwesomeIcons.fileLines,
      'car-alt': FontAwesomeIcons.car,
      'plane': FontAwesomeIcons.plane,
      'paste': FontAwesomeIcons.paste,
      'clock-o': FontAwesomeIcons.clock,
      'chalkboard': FontAwesomeIcons.chalkboard,
      'calendar-alt': FontAwesomeIcons.calendarDays,
      'laptop': FontAwesomeIcons.laptop,
      'questionCircle': FontAwesomeIcons.circleQuestion,
      // Add more mappings as needed.
    };

    return iconMap[iconName] ?? FontAwesomeIcons.circleQuestion;
  }

  /// Provides a fallback Material icon based on the card title.
  static IconData _getIconForTitle(String title) {
    if (title.contains('Vacation')) return Icons.beach_access;
    if (title.contains('Leave') && title.contains('Personal')) return Icons.access_time;
    if (title.contains('Leave') && title.contains('Sick')) return Icons.local_hospital;
    if (title.contains('History')) return Icons.history;
    if (title.contains('HR')) return Icons.group;
    if (title.contains('Request')) return Icons.assignment;
    if (title.contains('Track')) return Icons.pin_drop;
    return Icons.help_outline; // Default fallback icon.
  }

 static String _getRouteNameForTitle(String title) {
  if (title.contains('History') && title.contains('Vacation')) return '/vacation-history';
  if (title.contains('History') && title.contains('Leave')) return '/leaves-history';
  if (title.contains('Leave') && title.contains('Personal')) return '/personal-leave-request';
  if (title.contains('Leave') && title.contains('Sick')) return '/sick-leave-request';
  if (title.contains('Vacation')) return '/vacation-request';
  if (title.contains('HR')) return '/hr-request';
  if (title.contains('Request')) return '/track-my-request';
  if (title.contains('Track')) return '/track-my-request';
  return '/home'; // Fallback route if no match is found.
}

}
