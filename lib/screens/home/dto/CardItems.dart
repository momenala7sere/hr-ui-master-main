import 'package:flutter/material.dart';
import 'package:hr/screens/home/components/CardData.dart';
import 'package:hr/state_management/localization_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


// List of predefined CardData objects
final List<CardData> cardItems = [
  // Requests
  CardData(
    title: LocalizationService.translate('vacation_request') ?? 'Vacation Request',
    icon: Icons.beach_access, // Preferred icon for Vacation Request
    color: const Color(0xFFCE5E52),
    routeName: '/vacation-request',
  ),
  CardData(
    title: LocalizationService.translate('leave_request') ?? 'Leave Request',
    icon: Icons.schedule,
    color: const Color(0xFFCE5E52),
    routeName: '/leave-request',
  ),
  // History
  CardData(
    title: LocalizationService.translate('vacations_history') ?? 'Vacations History',
    icon: Icons.pending_actions,
    color: const Color(0xFFCE5E52),
    routeName: '/vacation-history',
  ),
  CardData(
    title: LocalizationService.translate('leaves_history') ?? 'Leaves History',
    icon: Icons.content_paste_go_rounded,
    color: const Color(0xFFCE5E52),
    routeName: '/leaves-history',
  ),

  // Other
  CardData(
    title: LocalizationService.translate('hr_request') ?? 'HR Request',
    icon: Icons.groups,
    color: const Color(0xFFCE5E52),
    routeName: '/hr-request',
  ),
  CardData(
    title: LocalizationService.translate('hr_requests_history') ?? 'HR Requests History',
    icon: Icons.history,
    color: const Color(0xFFCE5E52),
    routeName: '/hr-requests-history',
  ),
  CardData(
    title: LocalizationService.translate('track_my_request') ?? 'Track My Request',
    icon: Icons.pin_drop,
    color: const Color(0xFFCE5E52),
    routeName: '/track-my-request',
  ),
];
