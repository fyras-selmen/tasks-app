import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tasks_app/models/task.dart';

/// Service API pour gérer les requêtes HTTP
class ApiService {
  final String baseUrl = 'https://example.com/api'; // URL de base de l'API

  /// S'inscrire
  Future<bool> signUp(String email, String password, String cPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup/'),
      body: {'email': email, 'password': password, 'confirmPassword': password},
    );
    if (response.statusCode == 200) {
      // Gérer l'inscription réussie
      return true;
    } else {
      // Gérer l'erreur
      return false;
    }
  }

  /// Se connecter
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      // Gérer la connexion réussie (par exemple, enregistrer le token)
      return true;
    } else {
      // Gérer l'erreur
      return false;
    }
  }

  /// Se déconnecter
  Future<bool> logout() async {
    final response = await http.get(
      Uri.parse('$baseUrl/logout/'),
    );
    if (response.statusCode == 200) {
      // Gérer la déconnexion réussie (par exemple, effacer le token)
      return true;
    } else {
      // Gérer l'erreur
      return false;
    }
  }

  /// Stocker les tâches vers l'API
  Future<bool> uploadTasks(List<Task> tasks) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todo/'),
      body: {
        "tasks": jsonEncode(tasks)
      }, // Convertir la liste des tâches en JSON
    );
    if (response.statusCode == 200) {
      return true; // Succès
    } else {
      return false; // Échec
    }
  }
}
