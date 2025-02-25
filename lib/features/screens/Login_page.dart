import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr/api/api_service.dart';
import 'package:hr/state_management/generic_bloc.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';
import 'package:hr/state_management/localization_service.dart';
import 'package:hr/screens/home/HomePage.dart';

class LoginPage extends StatefulWidget {
  final Function(Locale) onChangeLanguage;
  final Locale currentLocale;

  const LoginPage({
    Key? key,
    required this.onChangeLanguage,
    required this.currentLocale,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = 'MobileUser';
    _passwordController.text = r'K@rAPI$$UserAdmin&&';
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final savedUsername = await _secureStorage.read(key: 'username');
    final savedPassword = await _secureStorage.read(key: 'password');

    if (savedUsername != null && savedPassword != null) {
      setState(() {
        _usernameController.text = savedUsername;
        _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  Future<void> _saveCredentials(String username, String password) async {
    if (_rememberMe) {
      await _secureStorage.write(key: 'username', value: username);
      await _secureStorage.write(key: 'password', value: password);
    } else {
      await _secureStorage.delete(key: 'username');
      await _secureStorage.delete(key: 'password');
    }
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog(LocalizationService.translate('fill_credentials'));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Attempting login with Username: $username, Password: $password');

      final token = await ApiService().getToken(username, password);
      print('Login Successful. Token: $token');

      await _saveCredentials(username, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            currentLocale: widget.currentLocale,
            token: token,
          ),
        ),
      );
    } catch (e) {
      print('Login Failed: $e');
      _showErrorDialog(LocalizationService.translate('login_failed'));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocalizationService.translate('Error')),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocalizationService.translate('ok')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the content in SafeArea and SingleChildScrollView to handle keyboard appearance.
    return Scaffold(
      backgroundColor: const Color(0xff3D3D3D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ConstrainedBox(
            // Ensure the column fills the available height
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Logo and header
                  const SizedBox(height: 40),
                  const Image(
                    image: AssetImage('assets/images/karlogo.png'),
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 50),
                  // Username text field
                  _buildTextField(
                    controller: _usernameController,
                    label: LocalizationService.translate('username'),
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  // Password text field
                  _buildTextField(
                    controller: _passwordController,
                    label: LocalizationService.translate('password'),
                    icon: Icons.lock,
                    isPassword: true,
                    onVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    isPasswordVisible: _isPasswordVisible,
                  ),
                  const SizedBox(height: 20),
                  _buildRememberMeRow(),
                  const SizedBox(height: 20),
                  _buildLoginButton(),
                  const SizedBox(height: 30),
                  _buildLanguageToggle(),
                  // Spacer to push the footer to the bottom
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      '© ${DateTime.now().year} All rights reserved',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.apps, color: Color(0xffCE5E52), size: 40),
        SizedBox(width: 10),
        Text(
          'E-Service System',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        // Added contentPadding to prevent overlapping issues
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
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
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              activeColor: const Color(0xffCE5E52),
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
            ),
            Text(
              LocalizationService.translate('remember_me'),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/reset-password'),
          child: Text(
            LocalizationService.translate('forgot_password'),
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffCE5E52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        minimumSize: const Size(380, 50),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              LocalizationService.translate('login'),
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
    );
  }

  Widget _buildLanguageToggle() {
    return TextButton(
      onPressed: () {
        if (widget.currentLocale.languageCode == 'en') {
          widget.onChangeLanguage(const Locale('ar', 'EG'));
        } else {
          widget.onChangeLanguage(const Locale('en', 'US'));
        }
      },
      child: Text(
        widget.currentLocale.languageCode == 'en' ? "عربي" : "English",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
