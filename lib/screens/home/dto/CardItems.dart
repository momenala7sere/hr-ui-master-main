import 'package:flutter/material.dart';
import 'package:hr/screens/home/components/CardData.dart';
import 'package:hr/state_management/localization_service.dart';

// List of predefined CardData objects
final List<CardData> cardItems = [
  // Requests (8 cards)
  CardData(
    title:
        LocalizationService.translate('vacation_request') ?? 'Vacation Request',
    icon: Icons.person_add,
    color: const Color(0xFFCE5E52),
    routeName: '/vacation-request',
  ),
  CardData(
    title: LocalizationService.translate('leave_request') ?? 'Leave Request',
    icon: Icons.schedule,
    color: const Color(0xFFCE5E52),
    routeName: '/leave-request',
  ),
  CardData(
    title:
        LocalizationService.translate('personal') ?? 'Personal Leave Request',
    icon: Icons.access_time,
    color: const Color(0xFFCE5E52),
    routeName: '/personal',
  ),
  CardData(
    title: LocalizationService.translate('sick leave request') ??
        'Sick Leave Request',
    icon: Icons.local_hospital,
    color: const Color(0xFFCE5E52),
    routeName: '/sick',
  ),
  CardData(
    title: LocalizationService.translate('emergency_leave_request') ??
        'Emergency Leave Request',
    icon: Icons.warning,
    color: const Color(0xFFCE5E52),
    routeName: '/emergency',
  ),
  CardData(
    title: LocalizationService.translate('paid_leave_request') ??
        'Paid Leave Request',
    icon: Icons.attach_money,
    color: const Color(0xFFCE5E52),
    routeName: '/paid',
  ),
  CardData(
    title:
        LocalizationService.translate('vacation_request') ?? 'Vacation Request',
    icon: Icons.beach_access,
    color: const Color(0xFFCE5E52),
    routeName: '/vacation',
  ),
  CardData(
    title: LocalizationService.translate('official_leave_request') ??
        'Official Leave Request',
    icon: Icons.business,
    color: const Color(0xFFCE5E52),
    routeName: '/official',
  ),

  // History (8 cards)
  CardData(
    title: LocalizationService.translate('vacations_history') ??
        'Vacations History',
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
  CardData(
    title: LocalizationService.translate('approved leaves history') ??
        'Approved Leaves History',
    icon: Icons.check_circle,
    color: const Color(0xFFCE5E52),
    routeName: '/approved',
  ),
  CardData(
    title: LocalizationService.translate('pending_leaves_history') ??
        'Pending Leaves History',
    icon: Icons.pending,
    color: const Color(0xFFCE5E52),
    routeName: '/pending',
  ),
  CardData(
    title: LocalizationService.translate('rejected_leaves_history') ??
        'Rejected Leaves History',
    icon: Icons.cancel,
    color: const Color(0xFFCE5E52),
    routeName: '/rejected',
  ),
  CardData(
    title: LocalizationService.translate('leave_request_status') ??
        'Leave Request Status',
    icon: Icons.list,
    color: const Color(0xFFCE5E52),
    routeName: '/leavee',
  ),
  CardData(
    title: LocalizationService.translate('sick_leave_history') ??
        'Sick Leave History',
    icon: Icons.local_hospital,
    color: const Color(0xFFCE5E52),
    routeName: '/sickk',
  ),
  CardData(
    title: LocalizationService.translate('official_leave_history') ??
        'Official Leave History',
    icon: Icons.business,
    color: const Color(0xFFCE5E52),
    routeName: '/official',
  ),

  // Other (6 cards)
  CardData(
    title: LocalizationService.translate('hr_request') ?? 'HR Request',
    icon: Icons.groups,
    color: const Color(0xFFCE5E52),
    routeName: '/Hr-request',
  ),
  CardData(
    title: LocalizationService.translate('hr_requests_history') ??
        'HR Requests History',
    icon: Icons.history,
    color: const Color(0xFFCE5E52),
    routeName: '/Hr-requests-history',
  ),
  CardData(
    title:
        LocalizationService.translate('track_my_request') ?? 'Track My Request',
    icon: Icons.pin_drop,
    color: const Color(0xFFCE5E52),
    routeName: '/track-my-request',
  ),
  CardData(
    title: LocalizationService.translate('employee_directory') ??
        'Employee Directory',
    icon: Icons.account_circle,
    color: const Color(0xFFCE5E52),
    routeName: '/employee-directory',
  ),
  CardData(
    title:
        LocalizationService.translate('company_policies') ?? 'Company Policies',
    icon: Icons.policy,
    color: const Color(0xFFCE5E52),
    routeName: '/company-policies',
  ),
  CardData(
    title: LocalizationService.translate('leave_balance') ?? 'Leave Balance',
    icon: Icons.account_balance_wallet,
    color: const Color(0xFFCE5E52),
    routeName: '/leave-balance',
  ),
];
