import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

class ApiTestScreen extends StatefulWidget {
  @override
  _ApiTestScreenState createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  String? token;
  String? apiResponse;

  // Create a custom HttpClient to bypass SSL certificate validation
  HttpClient createHttpClient() {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }

  // Method to get the token
  Future<void> getToken() async {
    final url =
        Uri.parse('https://app.karbusiness.com/DMS.Mobile.API/API/Login/Login');
    try {
      final ioClient = IOClient(createHttpClient());
      final response = await ioClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'UserName': 'MobileUser', 'Password': r'K@rAPI$$UserAdmin&&'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['response'] != null) {
          setState(() {
            token = data['response'][0]['token'];
            apiResponse = 'Token fetched successfully!';
          });
        } else {
          setState(() {
            token = null;
            apiResponse = 'Error: Token not found in response.';
          });
        }
      } else {
        setState(() {
          token = null;
          apiResponse = 'Error: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        apiResponse = 'Failed to fetch token: $e';
      });
    }
  }

  // Method to fetch user menu
  Future<void> getUserMenu() async {
    if (token == null || token!.isEmpty) {
      setState(() {
        apiResponse = 'No token available. Please log in first.';
      });
      return;
    }

    final url = Uri.parse(
        'https://app.karbusiness.com/DMS.Mobile.API/API/Users/GetUserMenu');
    try {
      final ioClient = IOClient(createHttpClient());
      final response = await ioClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Token': token!,
        },
        body: jsonEncode({'UserID': 1}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          apiResponse = data.toString();
        });
      } else {
        setState(() {
          apiResponse = 'Error: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        apiResponse = 'Failed to fetch user menu: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Test Screen')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: getToken,
                child: Text('Get Token'),
              ),
              if (token != null)
                Text('Token: $token', style: TextStyle(color: Colors.green)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: getUserMenu,
                child: Text('Get User Menu'),
              ),
              SizedBox(height: 16),
              if (apiResponse != null) Text('API Response:\n$apiResponse'),
            ],
          ),
        ),
      ),
    );
  }
}
