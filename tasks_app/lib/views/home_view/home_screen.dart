import 'package:flutter/material.dart';
import 'package:tasks_app/views/home_view/calendar_view.dart';
import 'package:tasks_app/views/home_view/profile_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "Gestionnaire de tâches",
            style: TextStyle(
                color: Colors.deepPurple,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (i) async {
              setState(() {
                _selectedIndex = i;
              });
              await _controller.animateToPage(_selectedIndex,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceInOut);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calendar_month,
                    color:
                        _selectedIndex == 0 ? Colors.deepPurple : Colors.black,
                  ),
                  label: "Calendrier"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person,
                      color: _selectedIndex == 1
                          ? Colors.deepPurple
                          : Colors.black),
                  label: "Profil")
            ]),
        body: PageView(
          controller: _controller,
          onPageChanged: (i) {
            setState(() {
              _selectedIndex = i;
            });
          },
          children: const [CalendarView(), ProfileView()],
        ));
  }
}
