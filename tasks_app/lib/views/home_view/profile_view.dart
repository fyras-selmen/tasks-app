import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasks_app/controllers/providers/auth_provider.dart';
import 'package:tasks_app/controllers/providers/task_provider.dart';
import 'package:tasks_app/utils/utils.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool notifications = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Divider(
          color: Colors.deepPurple,
        ),
        100.ph,
        Center(
          child: Container(
            height: 50,
            width: ScreenUtil().screenWidth * 0.8,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: () async {
                final ref = ProviderScope.containerOf(context);
                await ref.read(taskProvider.notifier).uploadTasks();
              },
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Sauvegarder mes tâches",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            height: 50,
            width: ScreenUtil().screenWidth * 0.8,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                final ref = ProviderScope.containerOf(context);
                ref.read(authProvider.notifier).logout();
                Navigator.of(context).pushReplacementNamed("/login");
              },
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Se déconnecter",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
