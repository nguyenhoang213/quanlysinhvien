import 'package:flutter/material.dart';
import 'package:quanlysinhvien/student/student_home_screen.dart';
import 'package:quanlysinhvien/student/student_info_screen.dart';
import 'package:quanlysinhvien/student/student_notification_screen.dart';

class StudentScreen extends StatefulWidget {
  final String? email;
  const StudentScreen({super.key, this.email});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int _selectedIndex = 0;
  String? _email;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _screens = [
      StudentHomeScreen(email: _email),
      StudentNotificationScreen(),
      StudentInfoScreen(email: _email)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
