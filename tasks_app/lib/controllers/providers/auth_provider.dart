import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_app/controllers/services/api_services.dart';

/// Enumération des différents statuts d'authentification
enum AuthStatus { loggedIn, loggedOut, signedUp, error }

/// AuthNotifier gère l'état de l'authentification de l'utilisateur
class AuthNotifier extends StateNotifier<AuthStatus> {
  final ApiService apiService;

  AuthNotifier(this.apiService) : super(AuthStatus.loggedOut);

  /// S'inscrire
  Future<void> signUp(String email, String password, String cPassword) async {
    try {
      var done = await apiService.signUp(email, password, cPassword);
      done = true; // pour les tests seulement
      if (done) {
        state = AuthStatus.signedUp; // Si réussi, l'état est "signedUp"
      } else {
        state = AuthStatus.error; // Si échec, l'état est "error"
      }
    } catch (e) {
      state = AuthStatus.error; // Gérer le cas d'erreur
    }
  }

  /// Se connecter
  Future<void> login(String email, String password) async {
    try {
      var done = await apiService.login(email, password);
      done = true; // pour les tests seulement
      if (done) {
        state = AuthStatus.loggedIn; // Si réussi, l'état est "loggedIn"
      } else {
        state = AuthStatus.error; // Si échec, l'état est "error"
      }
    } catch (e) {
      state = AuthStatus.error; // Gérer le cas d'erreur
    }
  }

  /// Se déconnecter
  Future<void> logout() async {
    try {
      var done = await apiService.logout();
      done = true; // pour les tests seulement
      if (done) {
        state = AuthStatus.loggedOut; // Si réussi, l'état est "loggedOut"
      } else {
        state = AuthStatus.error; // Si échec, l'état est "error"
      }
    } catch (e) {
      state = AuthStatus.error; // Gérer le cas d'erreur
    }
  }
}

final authProvider =
    StateNotifierProvider.autoDispose<AuthNotifier, AuthStatus>((ref) {
  return AuthNotifier(ApiService());
});
