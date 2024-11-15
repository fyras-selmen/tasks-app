import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tasks_app/models/task.dart';

class ApiService {
  final String baseUrl = 'https://example.com/api';

  Future<bool> signUp(String email, String password, String cPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup/'),
      body: {'email': email, 'password': password, 'confirmPassword': password},
    );
    if (response.statusCode == 200) {
      // Handle successful signup (e.g., save token)
      return true;
    } else {
      // Handle error (e.g., show error message)
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      // Handle successful login (e.g., save token)
      return true;
    } else {
      // Handle error (e.g., show error message)
      return false;
    }
  }

  Future<bool> logout() async {
    final response = await http.get(
      Uri.parse('$baseUrl/logout/'),
    );
    if (response.statusCode == 200) {
      // Handle successful logout (e.g., clear token)
      return true;
    } else {
      // Handle error (e.g., show error message)
      return false;
    }
  }

  Future<bool> uploadTasks(List<Task> tasks) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todo/'),
      body: {"tasks": jsonEncode(tasks)},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
