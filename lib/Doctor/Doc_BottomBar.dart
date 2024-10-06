import 'package:flutter/material.dart';
import 'package:healthapp/Doctor/Doc_Appointment_Screen.dart';
import 'package:healthapp/Doctor/Doc_Profile.dart';
import 'package:healthapp/Screens/Home_Screen.dart';
import 'package:healthapp/Screens/ProfileScreen.dart';

class DocBottomNavBar extends StatefulWidget {
  final String userid;
  DocBottomNavBar({
    required this.userid,
  });

  @override
  _DocBottomNavBarState createState() => _DocBottomNavBarState();
}

class _DocBottomNavBarState extends State<DocBottomNavBar> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions() {
    return [
      DocAppointmentscreen(
        userid: widget.userid,
      ),
      DocProfile(
        userid: widget.userid,
      ),
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
      body: Center(
        child: _widgetOptions().elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
