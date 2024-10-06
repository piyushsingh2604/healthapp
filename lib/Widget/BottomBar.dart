import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/Screens/AboutScreen.dart';
import 'package:healthapp/Screens/AppointmentScreen.dart';
import 'package:healthapp/Doctor/Doc_Appointment_Screen.dart';
import 'package:healthapp/Screens/Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/Screens/Home_Screen.dart';
import 'package:healthapp/Screens/ProfileScreen.dart';
import 'package:healthapp/Screens/Search.dart';
import 'package:healthapp/Widget/Patient_Appointment_Widget.dart';
import 'package:rxdart/rxdart.dart';

class BottomNavBar extends StatefulWidget {
  final String name;
  final String userid;
  BottomNavBar({required this.userid, required this.name});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions() {
    return [
      HomeScreen(
        name: widget.name,
        uid: widget.userid,
      ),
      Appointmentscreen(
        userid: widget.userid,
      ),
      Profilescreen(
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
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
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
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String userId;

  ProfileScreen({required this.userId});

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    final userAppointments = await FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .get();

    return userAppointments.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Appointments"),
        backgroundColor: Colors.indigo[900],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final appointments = snapshot.data ?? [];
          if (appointments.isEmpty) {
            return Center(child: Text("No appointments found."));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Patient Name: ${appointment['patientName'] ?? 'N/A'}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Mobile: ${appointment['mobile'] ?? 'N/A'}"),
                      Text("Date: ${appointment['date'] ?? 'N/A'}"),
                      Text("Time: ${appointment['time'] ?? 'N/A'}"),
                      Text(
                          "Description: ${appointment['description'] ?? 'N/A'}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SentAppointmentsScreen extends StatelessWidget {
  final String userId;

  SentAppointmentsScreen({required this.userId});

  Future<List<Map<String, dynamic>>> fetchSentAppointments() async {
    print(
        "Fetching sent appointments for senderId: $userId"); // Updated log statement

    final userAppointments = await FirebaseFirestore.instance
        .collection('appointments')
        .where('senderId', isEqualTo: userId) // Changed from userId to senderId
        .get();

    print("Number of sent appointments found: ${userAppointments.docs.length}");

    return userAppointments.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sent Appointments"),
        backgroundColor: Colors.indigo[900],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSentAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final appointments = snapshot.data ?? [];
          if (appointments.isEmpty) {
            return Center(child: Text("No sent appointments found."));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Patient Name: ${appointment['patientName'] ?? 'N/A'}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Mobile: ${appointment['mobile'] ?? 'N/A'}"),
                      Text("Date: ${appointment['date'] ?? 'N/A'}"),
                      Text("Time: ${appointment['time'] ?? 'N/A'}"),
                      Text(
                          "Description: ${appointment['description'] ?? 'N/A'}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
