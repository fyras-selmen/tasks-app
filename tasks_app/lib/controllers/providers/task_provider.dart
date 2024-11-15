import 'dart:convert';
import 'dart:developer';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_app/controllers/services/api_services.dart';
import 'package:tasks_app/controllers/services/cache_services.dart';
import 'package:tasks_app/controllers/services/notification_services.dart';
import 'package:tasks_app/models/task.dart';

/// TaskNotifier gère l'état de la liste des tâches
class TaskNotifier extends StateNotifier<List<Task>> {
  final ApiService apiService;

  TaskNotifier(this.apiService) : super([]);

  /// Ajouter une tâche
  Future<void> addTask(Task task) async {
    try {
      // Crée un modèle de cache pour stocker les tâches
      APICacheDBModel tasksModel = APICacheDBModel(
          key: task.date.toString(), syncData: jsonEncode([...state, task]));

      // Enregistre les données dans le cache
      bool done = await CacheServices.setData(task.date.toString(), tasksModel);
      if (done) {
        // Si la notification est activée
        if (task.sendNotification) {
          NotificationService ns = NotificationService();
          await ns.scheduleTaskNotification(
              title: "Rappel de Tâche",
              body: "N'oubliez pas de compléter votre tâche : ${task.title}",
              scheduledDateTime: dateTimeMerge(task.date, task.startTime));
        }

        // Met à jour l'état avec la nouvelle tâche ajoutée
        state = [...state, task];
      } else {
        // Gérer l'erreur : tâche non ajoutée
      }
    } catch (e) {
      log(e.toString()); // Gérer l'erreur
    }
  }

  /// Récupérer les tâches d'un jour spécifique
  Future<void> getTasks(DateTime day) async {
    // Vérifie si les tâches pour ce jour sont dans le cache
    if (await CacheServices.containsKey(day.toString())) {
      final tasksModel = await CacheServices.getData(day.toString());

      // Convertir les données du cache en liste de tâches
      final tasks = taskListFromJson(jsonDecode(tasksModel.syncData));
      state = tasks; // Met à jour l'état avec les tâches récupérées
    }
  }

  /// Stocker toutes les tâches vers l'API
  Future<void> uploadTasks() async {
    try {
      List<Task> tasks = [];
      var list = await CacheServices
          .getAllData(); // Récupère toutes les données du cache
      for (var e in list) {
        tasks.addAll(taskListFromJson(
            jsonDecode(e.syncData))); // Ajoute chaque tâche à la liste
      }
      var done =
          await apiService.uploadTasks(tasks); // Stocker les tâches vers l'API
      if (done) {
        // Gérer le succès
      } else {
        // Gérer l'échec
      }
    } catch (e) {
      log(e.toString()); // Gérer l'erreur
    }
  }

  /// Fonction pour combiner une date et une heure en un seul objet DateTime
  DateTime dateTimeMerge(DateTime date, String time) {
    // Analyse la chaîne de caractères représentant l'heure
    List<String> timeParts = time.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Crée un objet DateTime final en combinant la date et l'heure fournies
    DateTime finalDatetime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
    return finalDatetime;
  }
}

final taskProvider =
    StateNotifierProvider.autoDispose<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(ApiService());
});
