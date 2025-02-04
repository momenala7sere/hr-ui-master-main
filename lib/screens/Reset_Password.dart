import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr/state_management/generic_bloc.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';
import 'package:hr/state_management/localization_service.dart';

class ResetPassword extends StatefulWidget {
  final Locale currentLocale;

  const ResetPassword({Key? key, required this.currentLocale}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';
  bool _isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GenericBloc(
        submitDataCallback: (data) async {
          final email = data['email'];
          if (email.isEmpty || !email.contains('@')) {
            throw Exception(LocalizationService.translate('invalid_email'));
          }
          print("Simulating API call with email: $email");
          await Future.delayed(const Duration(seconds: 2));
          return 'Success';
        },
      ),
      child: BlocConsumer<GenericBloc, GenericState>(
        listener: (context, state) {
          if (state is GenericLoaded) {
            print("Success! Showing dialog.");
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(LocalizationService.translate('success')),
                content: Text(LocalizationService.translate('reset_password_success')),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: Text(LocalizationService.translate('ok')),
                  ),
                ],
              ),
            );
          } else if (state is GenericError) {
            setState(() {
              _errorMessage = state.message;
              print("Error received: $_errorMessage");
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is GenericLoading;

          return Scaffold(
            backgroundColor: const Color(0xff3D3D3D),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Header section with icon and title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.restart_alt,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              LocalizationService.translate('reset_password'),
                              style: const TextStyle(
                                fontSize: 34.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          LocalizationService.translate('enter_email'),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        // Email input field with improved content padding
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.mail, color: Colors.white),
                            labelText: LocalizationService.translate('email_placeholder'),
                            labelStyle: const TextStyle(color: Colors.white),
                            errorText: _errorMessage.isEmpty ? null : _errorMessage,
                            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.white54),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            setState(() {
                              _errorMessage = '';
                              _isButtonEnabled = value.trim().isNotEmpty && value.contains('@');
                              print("Email Valid: $_isButtonEnabled");
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),
                        // Submit button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: Size(MediaQuery.of(context).size.width, 40.0),
                            backgroundColor: _isButtonEnabled ? const Color(0xffCE5E52) : Colors.grey,
                          ),
                          onPressed: isLoading || !_isButtonEnabled
                              ? null
                              : () {
                                  final email = _emailController.text.trim();
                                  print("Submitting email: $email");
                                  context.read<GenericBloc>().add(
                                        SubmitData(data: {'email': email}),
                                      );
                                },
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  LocalizationService.translate('submit'),
                                  style: const TextStyle(color: Colors.white, fontSize: 18),
                                ),
                        ),
                        const SizedBox(height: 20),
                        // Back to login row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed('/login');
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    LocalizationService.translate('back_to_login'),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Spacer pushes the content upward if there's extra space
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Copyright © ${DateTime.now().year}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
