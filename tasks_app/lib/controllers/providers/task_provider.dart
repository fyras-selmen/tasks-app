import 'dart:convert';
import 'dart:developer';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_app/controllers/services/api_services.dart';
import 'package:tasks_app/controllers/services/cache_services.dart';
import 'package:tasks_app/controllers/services/notification_services.dart';
import 'package:tasks_app/models/task.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  final ApiService apiService;

  TaskNotifier(this.apiService) : super([]);

  Future<void> addTask(Task task) async {
    try {
      APICacheDBModel tasksModel = APICacheDBModel(
          key: task.date.toString(), syncData: jsonEncode([...state, task]));

      bool done = await CacheServices.setData(task.date.toString(), tasksModel);
      if (done) {
        if (task.sendNotification) {
          NotificationService ns = NotificationService();
          await ns.scheduleTaskNotification(
              title: "Rappel de Tâche",
              body: "N'oubliez pas de compléter votre tâche : ${task.title}",
              scheduledDateTime: dateTimeMerge(task.date, task.startTime));
        }

        state = [...state, task];
      } else {
        // Handle error : task not added
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getTasks(DateTime day) async {
    if (await CacheServices.containsKey(day.toString())) {
      final tasksModel = await CacheServices.getData(day.toString());

      final tasks = taskListFromJson(jsonDecode(tasksModel.syncData));
      state = tasks;
    }
  }

  Future<void> uploadTasks() async {
    try {
      List<Task> tasks = [];
      var list = await CacheServices.getAllData();
      for (var e in list) {
        tasks.addAll(taskListFromJson(jsonDecode(e.syncData)));
      }
      var done = await apiService.uploadTasks(tasks);
      if (done) {
        // Handle success
      } else {
        // Handle failure
      }
    } catch (e) {
      log(e.toString());
    }
  }

  DateTime dateTimeMerge(DateTime date, String time) {
    // Parse the original datetime string as UTC

    // Parse the time string
    List<String> timeParts = time.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Create a final datetime by combining date from original datetime (UTC) and time from time string
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

// Create a provider for the TaskNotifier
final taskProvider =
    StateNotifierProvider.autoDispose<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(ApiService());
});
