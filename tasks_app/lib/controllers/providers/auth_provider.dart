import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_app/controllers/services/api_services.dart';

enum AuthStatus { loggedIn, loggedOut, signedUp, error }

class AuthNotifier extends StateNotifier<AuthStatus> {
  final ApiService apiService;

  AuthNotifier(this.apiService) : super(AuthStatus.loggedOut);

  Future<void> signUp(String email, String password, String cPassword) async {
    try {
      var done = await apiService.signUp(email, password, cPassword);
      done = true; // for testing only
      if (done) {
        state = AuthStatus.signedUp;
      } else {
        state = AuthStatus.error;
      }
    } catch (e) {
      state = AuthStatus.error; // Handle error case
    }
  }

  Future<void> login(String email, String password) async {
    try {
      var done = await apiService.login(email, password);
      done = true; // for testing only
      if (done) {
        state = AuthStatus.loggedIn;
      } else {
        state = AuthStatus.error; // Handle error case
      }
    } catch (e) {
      state = AuthStatus.error; // Handle error case
    }
  }

  Future<void> logout() async {
    try {
      var done = await apiService.logout();
      done = true; //for Testing only
      if (done) {
        state = AuthStatus.loggedOut;
      } else {
        state = AuthStatus.error; // Handle error case
      }
    } catch (e) {
      state = AuthStatus.error; // Handle error case
    }
  }
}

// Provider for authentication state
final authProvider =
    StateNotifierProvider.autoDispose<AuthNotifier, AuthStatus>((ref) {
  return AuthNotifier(ApiService());
});
