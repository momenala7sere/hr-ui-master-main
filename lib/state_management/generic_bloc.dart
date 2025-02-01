import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr/api/api_service.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';

class GenericBloc extends Bloc<GenericEvent, GenericState> {
  final Future<dynamic> Function(Map<String, dynamic> data)? submitDataCallback;
  final Future<dynamic> Function()? fetchDataCallback;
  final ApiService apiService = ApiService();

  GenericBloc({this.submitDataCallback, this.fetchDataCallback}) : super(GenericInitial()) {
    on<SubmitData>(_onSubmitData);
    on<FetchData>(_onFetchData);
    on<SubmitLeaveRequest>(_onSubmitLeaveRequest);
    on<SubmitVacationRequest>(_onSubmitVacationRequest);
    on<FetchVacationHistory>(_onFetchVacationHistory);
    on<FetchLeaveBalances>(_onFetchLeaveBalances);

    // Inbox events
    on<FetchUnreadMessages>(_onFetchUnreadMessages);
    on<MarkMessageAsRead>(_onMarkMessageAsRead);
    on<RefreshInbox>(_onRefreshInbox);

    // Notifications event
    on<FetchNotifications>(_onFetchNotifications); // Added handler for notifications
  }

  // Fetch notifications
  Future<void> _onFetchNotifications(FetchNotifications event, Emitter<GenericState> emit) async {
    emit(GenericLoading());
    try {
      final response = await apiService.getUnreadNotifications(event.token);
      final notifications = response['response'] ?? [];
      emit(NotificationsLoaded(notifications)); // Use the NotificationsLoaded state
    } catch (e) {
      emit(GenericError('Failed to fetch notifications: $e'));
      print('Error in fetching notifications: $e');  // Log the error for debugging
    }
  }

  Future<void> _onSubmitData(SubmitData event, Emitter<GenericState> emit) async {
    emit(GenericLoading());
    try {
      if (submitDataCallback == null) {
        throw Exception("SubmitData callback is not implemented.");
      }
      final result = await submitDataCallback!(event.data);
      emit(GenericLoaded(result));
    } catch (e) {
      emit(GenericError(e.toString()));
      print('Error in SubmitData: $e');  // Log the error for debugging
    }
  }

  Future<void> _onFetchData(FetchData event, Emitter<GenericState> emit) async {
    emit(GenericLoading());
    try {
      if (fetchDataCallback == null) {
        throw Exception("FetchData callback is not implemented.");
      }
      final result = await fetchDataCallback!();
      emit(GenericLoaded(result));
    } catch (e) {
      emit(GenericError(e.toString()));
      print('Error in FetchData: $e');  // Log the error for debugging
    }
  }

  // Inbox: Fetch unread messages
  Future<void> _onFetchUnreadMessages(FetchUnreadMessages event, Emitter<GenericState> emit) async {
    emit(GenericLoading());
    try {
      final response = await apiService.getUnreadMessages(event.token);
      final messages = response['Messages'] ?? []; // Adjust key based on API response
      emit(GenericLoaded(messages));
    } catch (e) {
      emit(GenericError('Failed to fetch unread messages: $e'));
      print('Error in FetchUnreadMessages: $e');  // Log the error for debugging
    }
  }

  // Inbox: Mark a specific message as read
  Future<void> _onMarkMessageAsRead(MarkMessageAsRead event, Emitter<GenericState> emit) async {
    emit(GenericLoading());
    try {
      // Simulating marking message as read. Replace this with an actual API call if needed.
      await Future.delayed(const Duration(seconds: 1));
      emit(GenericLoaded({'messageId': event.messageId, 'status': 'read'}));
    } catch (e) {
      emit(GenericError('Failed to mark message as read: $e'));
      print('Error in MarkMessageAsRead: $e');  // Log the error for debugging
    }
  }

  // Inbox: Refresh inbox
  Future<void> _onRefreshInbox(RefreshInbox event, Emitter<GenericState> emit) async {
    emit(GenericLoading());
    try {
      final response = await apiService.getUnreadMessages(event.token); // Provide token if required
      final refreshedMessages = response['Messages'] ?? [];
      emit(GenericLoaded(refreshedMessages));
    } catch (e) {
      emit(GenericError('Failed to refresh inbox: $e'));
      print('Error in RefreshInbox: $e');  // Log the error for debugging
    }
  }

  // Leave request and other handlers (Unchanged)
  Future<void> _onSubmitLeaveRequest(SubmitLeaveRequest event, Emitter<GenericState> emit) async {
    emit(GenericLoading());
    try {
      final result = {
        'success': true,
        'message': 'Leave request submitted successfully!',
        'data': event.data,
      };
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      emit(GenericLoaded(result));
    } catch (e) {
      emit(GenericError('Failed to submit leave request: $e'));
      print('Error in SubmitLeaveRequest: $e');  // Log the error for debugging
    }
  }

  Future<void> _onSubmitVacationRequest(SubmitVacationRequest event, Emitter<GenericState> emit) async {
    emit(GenericLoading());
    try {
      final result = {
        'success': true,
        'message': 'Vacation request submitted successfully!',
        'data': event.data,
      };
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      emit(GenericLoaded(result));
    } catch (e) {
      emit(GenericError('Failed to submit vacation request: $e'));
      print('Error in SubmitVacationRequest: $e');  // Log the error for debugging
    }
  }

  Future<void> _onFetchVacationHistory(FetchVacationHistory event, Emitter<GenericState> emit) async {
    emit(GenericLoading());
    try {
      final List<Map<String, dynamic>> vacationHistory = [
        {
          'id': '2520',
          'employee': 'Mohammed',
          'requestDate': '01/06/2023 11:02:21',
          'requestType': 'Quota',
          'from': DateTime(2023, 6, 1),
          'to': DateTime(2023, 6, 10),
          'status': 'Requested',
        },
        {
          'id': '2521',
          'employee': 'Ali',
          'requestDate': '05/07/2023 09:15:30',
          'requestType': 'Sick',
          'from': DateTime(2023, 7, 5),
          'to': DateTime(2023, 7, 8),
          'status': 'Approved',
        },
      ];

      final fromDate = event.fromDate ?? DateTime(2000);
      final toDate = event.toDate ?? DateTime(2101);

      final filteredHistory = vacationHistory.where((record) {
        final recordFrom = record['from'] as DateTime;
        final recordTo = record['to'] as DateTime;
        return recordFrom.isAfter(fromDate.subtract(const Duration(days: 1))) &&
            recordTo.isBefore(toDate.add(const Duration(days: 1)));
      }).toList();

      emit(GenericLoaded(filteredHistory));
    } catch (e) {
      emit(GenericError('Failed to fetch vacation history: $e'));
      print('Error in FetchVacationHistory: $e');  // Log the error for debugging
    }
  }

  Future<void> _onFetchLeaveBalances(FetchLeaveBalances event, Emitter<GenericState> emit) async {
    emit(GenericLoading());
    try {
      final leaveBalance = await apiService.getLeaveBalance(event.token, event.userId);
      final sickLeaveBalance = await apiService.getSickLeaveBalance(event.token, event.userId);

      emit(GenericLoaded({
        'leaves': [
          {
            'balance': leaveBalance['response'][0]['balance'].toString(),
            'title': 'Annual Leave',
            'description': 'Available annual leave balance',
          },
          {
            'balance': sickLeaveBalance['response'][0]['balance'].toString(),
            'title': 'Sick Leave',
            'description': 'Available sick leave balance',
          },
        ],
      }));
    } catch (e) {
      emit(GenericError('Failed to fetch leave balances: $e'));
      print('Error in FetchLeaveBalances: $e');  // Log the error for debugging
    }
  }
}
