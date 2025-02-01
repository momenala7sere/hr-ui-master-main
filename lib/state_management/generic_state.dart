import 'package:equatable/equatable.dart';

abstract class GenericState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GenericInitial extends GenericState {}

class GenericLoading extends GenericState {}

class GenericLoaded extends GenericState {
  final dynamic data;

  GenericLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class GenericError extends GenericState {
  final String message;

  GenericError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State for when unread messages are loaded successfully
class UnreadMessagesLoaded extends GenericState {
  final List<dynamic> messages; // Replace with your message model if needed

  UnreadMessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// State for when a specific message is marked as read
class MessageMarkedAsRead extends GenericState {
  final int messageId;

  MessageMarkedAsRead(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

/// State for when the inbox is refreshed successfully
class InboxRefreshed extends GenericState {
  final List<dynamic> messages; // Replace with your message model if needed

  InboxRefreshed(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// State for when notifications are loaded successfully
class NotificationsLoaded extends GenericState {
  final List<dynamic> notifications; // Replace with your notification model if needed

  NotificationsLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}
