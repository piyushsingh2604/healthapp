import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentHistory extends StatelessWidget {
  final String userId;

  AppointmentHistory({required this.userId});
  Future<List<Map<String, dynamic>>> fetchSentAppointments() async {
    print("Fetching sent appointments for senderId: $userId");

    final userAppointments = await FirebaseFirestore.instance
        .collection('appointments')
        .where('senderId', isEqualTo: userId)
        .get();

    print("Number of sent appointments found: ${userAppointments.docs.length}");

    return userAppointments.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          "1.Dr.${appointment['doctorName'] ?? ""}",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 1),
                        child: Text(
                          "${appointment['date'] ?? 'N/A'}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 1),
                        child: Text(
                          "${appointment['description'] ?? 'N/A'}",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
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
