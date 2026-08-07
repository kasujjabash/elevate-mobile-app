import 'package:flutter/foundation.dart';
import 'package:era92_elevate/apis/api_client.dart';
import 'package:era92_elevate/apis/auth_api.dart';
import 'package:era92_elevate/models/app_user.dart';
import 'package:era92_elevate/providers/course_provider.dart';
import 'package:era92_elevate/services/session_storage.dart';

enum AuthStatus { unknown, authenticating, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthProvider({SessionStorage? sessionStorage})
      : _sessionStorage = sessionStorage ?? SessionStorage();

  final SessionStorage _sessionStorage;

  AuthStatus status = AuthStatus.unknown;
  AppUser? user;
  String? token;
  String? errorMessage;

  /// Restores a previously saved session, if any. Called once at app start.
  Future<void> tryAutoLogin() async {
    final session = await _sessionStorage.readSession();
    if (session == null) {
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    token = session.token;
    user = AppUser.fromJson(session.userJson);
    status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    status = AuthStatus.authenticating;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthApi.login(username: username, password: password);
      token = result.token;
      user = result.user;
      status = AuthStatus.authenticated;
      await _sessionStorage.saveSession(
        token: result.token,
        userJson: result.user.toJson(),
      );
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout({CourseProvider? courseProvider}) async {
    // Clear courses immediately so next student doesn't see stale data
    courseProvider?.clear();
    await _sessionStorage.clearSession();
    token = null;
    user = null;
    errorMessage = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
