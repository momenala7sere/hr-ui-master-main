class AuthService {
  static Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(seconds: 2));
    return false;
  }
}
