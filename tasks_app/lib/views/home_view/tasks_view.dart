import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app/controllers/providers/task_provider.dart';
import 'package:tasks_app/models/task.dart';
import 'package:tasks_app/utils/utils.dart';
import 'package:tasks_app/views/home_view/task_dialog.dart';

class TasksView extends ConsumerStatefulWidget {
  final DateTime day;
  const TasksView({super.key, required this.day});

  @override
  ConsumerState<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends ConsumerState<TasksView> {
  List<Task> tasks = [];
  @override
  void initState() {
    tasks = ref.read(taskProvider);
    ref.read(taskProvider.notifier).getTasks(widget.day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<List<Task>>(taskProvider, (previousTasks, currentTasks) {
      setState(() {
        tasks = ref.read(taskProvider);
      });
    });
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.deepPurple,
              )),
          title: Text(
            "Tâches du ${formatReadableDate(widget.day)}",
            style: const TextStyle(
                color: Colors.deepPurple, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple.withOpacity(0.6),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (w) {
                    return AddTaskDialog(
                      day: widget.day,
                    );
                  });
            }),
        body: tasks.isEmpty
            ? const Center(
                child: Text("Aucune tâche pour ce jour"),
              )
            : ListView.separated(
                reverse: true,
                itemBuilder: (context, i) {
                  return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.deepPurple,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  tasks.elementAt(i).title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${tasks.elementAt(i).startTime} - ${tasks.elementAt(i).endTime}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  5.pw,
                                  tasks.elementAt(i).sendNotification
                                      ? const Icon(
                                          Icons.notifications_active_outlined,
                                          color: Colors.deepPurple,
                                        )
                                      : Container()
                                ],
                              )
                            ],
                          ),
                          Text(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              tasks.elementAt(i).description),
                        ],
                      ));
                },
                separatorBuilder: (context, i) {
                  return const Divider();
                },
                itemCount: tasks.length));
  }

  static String formatReadableDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }
}
