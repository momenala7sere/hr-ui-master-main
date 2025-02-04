import 'package:equatable/equatable.dart';

abstract class GenericEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Generic event for submitting data
class SubmitData extends GenericEvent {
  final Map<String, dynamic> data;
  final Future<dynamic> Function(Map<String, dynamic> data)? submitDataCallback; // Callback for submitting data

  SubmitData({required this.data, this.submitDataCallback});

  @override
  List<Object?> get props => [data];  // Do not add callback to props
}

/// Event for fetching data (general-purpose)
class FetchData extends GenericEvent {
  final Future<dynamic> Function()? fetchDataCallback; // Callback for fetching data

  FetchData({this.fetchDataCallback});

  @override
  List<Object?> get props => [fetchDataCallback];
}

/// Event for submitting a leave request
class SubmitLeaveRequest extends GenericEvent {
  final Map<String, dynamic> data;

  SubmitLeaveRequest({required this.data});

  @override
  List<Object?> get props => [data];
}

/// Event for submitting a vacation request
class SubmitVacationRequest extends GenericEvent {
  final Map<String, dynamic> data;

  SubmitVacationRequest({required this.data});

  @override
  List<Object?> get props => [data];
}

/// Event for fetching vacation history with optional filters
class FetchVacationHistory extends GenericEvent {
  final DateTime? fromDate;
  final DateTime? toDate;

  FetchVacationHistory({this.fromDate, this.toDate});

  @override
  List<Object?> get props => [fromDate, toDate];
}

/// Event for fetching leave balances
class FetchLeaveBalances extends GenericEvent {
  final String token;
  final int userId;

  FetchLeaveBalances({required this.token, required this.userId});

  @override
  List<Object?> get props => [token, userId];
}

/// Event for fetching unread messages
class FetchUnreadMessages extends GenericEvent {
  final String token;

  FetchUnreadMessages({required this.token});

  @override
  List<Object?> get props => [token];
}

/// Event for marking a specific message as read
class MarkMessageAsRead extends GenericEvent {
  final int messageId;

  MarkMessageAsRead({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

/// Event for refreshing inbox
class RefreshInbox extends GenericEvent {
  final String token;

  RefreshInbox({required this.token});

  @override
  List<Object?> get props => [token];
}

/// Event for fetching notifications
class FetchNotifications extends GenericEvent {
  final String token;

  FetchNotifications({required this.token});

  @override
  List<Object?> get props => [token];
}

/// Event for fetching employee data
class FetchEmployeeData extends GenericEvent {
  final String token;
  final int userId;  // Added userId for fetching employee data

  FetchEmployeeData({required this.token, required this.userId});

  @override
  List<Object?> get props => [token, userId];  // Include userId in props for equality comparison
}
