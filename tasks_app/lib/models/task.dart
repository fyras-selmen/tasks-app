import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<Task> taskListFromJson(List<dynamic> jsonList) =>
    jsonList.map((json) => Task.fromJson(json)).toList();
String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final DateTime date;
  final bool sendNotification;

  Task({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.date,
    this.sendNotification = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      startTime: json["start_time"],
      endTime: json["end_time"],
      date: DateTime.parse(json['date']),
      sendNotification: json['send_notification'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'start_time': startTime,
        'end_time': endTime,
        'date': date.toIso8601String(),
        'send_notification': sendNotification,
      };
}

TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.jm();
  return TimeOfDay.fromDateTime(format.parse(tod));
}
