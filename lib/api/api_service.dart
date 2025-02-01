import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'https://app.karbusiness.com/DMS.Mobile.API/API';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // API Endpoints
  static const String loginEndpoint = 'Login/Login';
  static const String getLeaveBalanceEndpoint = 'Users/GetLeaveBalance';
  static const String getSickLeaveBalanceEndpoint = 'Users/GetSickLeaveBalance';
  static const String submitLeaveRequestEndpoint = 'Users/SubmitLeaveRequest';
  static const String getUnreadInboxCountEndpoint = 'Users/GetUnreadInboxCount';
  static const String getLeaveTypeEndpoint = 'Masters/GetLeaveType';
  static const String getUserMenuEndpoint = 'Users/GetUserMenu';
  static const String getVacationHistoryEndpoint = 'Users/GetVacationHistory'; // New endpoint

  // Create a custom HTTP client to bypass SSL validation
  HttpClient _createHttpClient() {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return httpClient;
  }

  // General API POST request method
  Future<Map<String, dynamic>> _postRequest(String endpoint, Map<String, dynamic> body, {String? token}) async {
    final client = IOClient(_createHttpClient());
    final url = Uri.parse('$baseUrl/$endpoint');

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Token': token,
    };

    print('POST Request to $endpoint');
    print('Headers: $headers');
    print('Body: ${jsonEncode(body)}');

    final response = await client.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success'] == true) {
        return responseBody;
      } else {
        throw Exception('API Error: ${responseBody['messageText']}');
      }
    } else {
      throw Exception('HTTP Error: ${response.statusCode} - ${response.body}');
    }
  }

  // General API GET request method
  Future<Map<String, dynamic>> _getRequest(String endpoint, {String? token}) async {
    final client = IOClient(_createHttpClient());
    final url = Uri.parse('$baseUrl/$endpoint');

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Token': token,
    };

    print('GET Request to $endpoint');
    print('Headers: $headers');

    final response = await client.get(
      url,
      headers: headers,
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Get token API call
  Future<String> getToken(String username, String password) async {
    try {
      final response = await _postRequest(
        loginEndpoint,
        {'UserName': username, 'Password': password},
      );
      final token = response['response']?[0]?['token'];
      if (token != null) {
        await _saveToken(token);
        return token;
      } else {
        throw Exception('Token not found in response.');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Save token securely
  Future<void> _saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
    print('Token saved successfully.');
  }

  // Retrieve saved token
  Future<String?> getSavedToken() async {
    final token = await _secureStorage.read(key: 'token');
    print('Retrieved Token: $token');
    return token;
  }

  // Clear saved token
  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'token');
    print('Token cleared successfully.');
  }

  // Get Leave Balance API call
  Future<Map<String, dynamic>> getLeaveBalance(String token, int userId) async {
    try {
      return await _postRequest(
        getLeaveBalanceEndpoint,
        {'UserID': userId},
        token: token,
      );
    } catch (e) {
      throw Exception('Failed to fetch leave balance: $e');
    }
  }

  // Get Sick Leave Balance API call
  Future<Map<String, dynamic>> getSickLeaveBalance(String token, int userId) async {
    try {
      return await _postRequest(
        getSickLeaveBalanceEndpoint,
        {'UserID': userId},
        token: token,
      );
    } catch (e) {
      throw Exception('Failed to fetch sick leave balance: $e');
    }
  }

  // Submit Leave Request API call
  Future<void> submitLeaveRequest(String token, Map<String, dynamic> leaveRequestData) async {
    try {
      await _postRequest(
        submitLeaveRequestEndpoint,
        leaveRequestData,
        token: token,
      );
    } catch (e) {
      throw Exception('Failed to submit leave request: $e');
    }
  }

  // Get Unread Notifications API call
  Future<Map<String, dynamic>> getUnreadNotifications(String token) async {
    try {
      return await _postRequest(
        getUnreadInboxCountEndpoint,
        {'EmpNo': 1},
        token: token,
      );
    } catch (e) {
      throw Exception('Failed to fetch unread notifications: $e');
    }
  }

  // Get Unread Messages API call
  Future<Map<String, dynamic>> getUnreadMessages(String token) async {
    try {
      final response = await _postRequest(
        getUnreadInboxCountEndpoint,
        {'EmpNo': 1},
        token: token,
      );
      print('Unread Messages Response: $response');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch unread messages: $e');
    }
  }

  // Get Leave Type API call
  Future<Map<String, dynamic>> getLeaveType(String token) async {
    try {
      final body = <String, dynamic>{};
      final response = await _postRequest(
        getLeaveTypeEndpoint,
        body,
        token: token,
      );

      // Validate response structure
      if (response.containsKey('response') && response['response'] != null) {
        final leaveTypes = response['response'];
        if (leaveTypes is List) {
          return response;
        } else {
          throw Exception('Unexpected response format: ${leaveTypes.toString()}');
        }
      } else {
        throw Exception('Response does not contain the expected "response" field or it is null.');
      }
    } catch (e) {
      throw Exception('Failed to fetch leave types: $e');
    }
  }

  // Get User Menu API call
  Future<Map<String, dynamic>> getUserMenu(String token, int userId) async {
    try {
      final response = await _postRequest(
        getUserMenuEndpoint,
        {'UserID': userId},
        token: token,
      );

      print('User Menu Response: $response');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch user menu: $e');
    }
  }

  // Get Vacation History API call
  Future<Map<String, dynamic>> getVacationHistory(DateTime fromDate, DateTime toDate, {String? token}) async {
    try {
      return await _postRequest(
        getVacationHistoryEndpoint,
        {
          'fromDate': fromDate.toIso8601String(),
          'toDate': toDate.toIso8601String(),
        },
        token: token,
      );
    } catch (e) {
      throw Exception('Failed to fetch vacation history: $e');
    }
  }
}
