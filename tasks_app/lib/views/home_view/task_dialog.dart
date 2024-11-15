import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_app/controllers/providers/task_provider.dart';
import 'package:tasks_app/models/task.dart';
import 'package:tasks_app/utils/utils.dart';

class AddTaskDialog extends StatefulWidget {
  final DateTime day;
  const AddTaskDialog({super.key, required this.day});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _notificationEnabled = false;

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != (isStartTime ? _startTime : _endTime)) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: AlertDialog(
          content: Column(
            children: [
              10.ph,
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    gapPadding: 10,
                    borderSide: const BorderSide(color: Colors.deepPurple),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      gapPadding: 10,
                      borderSide: const BorderSide(
                        color: Colors.deepPurple,
                      )),
                ),
              ),
              10.ph,
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.deepPurple,
                      )),
                ),
              ),
              10.ph,
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        title: Text(_startTime == null
                            ? 'Heure de début'
                            : _startTime!.format(context)),
                        trailing: const Icon(Icons.access_time),
                        onTap: () => _selectTime(context, true),
                      ),
                    ),
                  ),
                ],
              ),
              10.ph,
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        title: Text(_endTime == null
                            ? 'Heure de fin'
                            : _endTime!.format(context)),
                        trailing: const Icon(Icons.access_time),
                        onTap: () => _selectTime(context, false),
                      ),
                    ),
                  ),
                ],
              ),
              10.ph,
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8)),
                child: SwitchListTile(
                  title: const Text('Notification'),
                  value: _notificationEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationEnabled = value;
                    });
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text(
                'Ajouter',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                String title = _titleController.text;
                String description = _descriptionController.text;

                if (title.isNotEmpty &&
                    description.isNotEmpty &&
                    _startTime != null &&
                    _endTime != null) {
                  // Vérifie si l'heure de début est avant l'heure de fin
                  if (_startTime!.hour + _startTime!.minute / 60 <
                          _endTime!.hour + _endTime!.minute / 60 &&
                      // Vérifie si l'heure actuelle est avant l'heure de début
                      TimeOfDay.now().hour + TimeOfDay.now().minute / 60 <
                          _startTime!.hour + _startTime!.minute / 60 &&
                      // Vérifie si l'heure de début est avant l'heure de fin
                      _startTime!.hour + _startTime!.minute / 60 <
                          _endTime!.hour + _endTime!.minute / 60) {
                    final ref = ProviderScope.containerOf(context);
                    ref.read(taskProvider.notifier).addTask(Task(
                        title: title,
                        description: description,
                        startTime:
                            "${_startTime!.hour < 10 ? "0" : ""}${_startTime!.hour}:${_startTime!.minute < 10 ? "0" : ""}${_startTime!.minute}",
                        endTime:
                            "${_endTime!.hour < 10 ? "0" : ""}${_endTime!.hour}:${_startTime!.minute < 10 ? "0" : ""}${_endTime!.minute}",
                        date: widget.day,
                        sendNotification: _notificationEnabled));
                  } else {
                    log("Gérer le message du temps saisis incorrecte");
                  }
                } else {
                  log("Gérer le message des données saisis incorrectes");
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
