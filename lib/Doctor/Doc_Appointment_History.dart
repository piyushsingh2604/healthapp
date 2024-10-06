import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DocAppointmentHistory extends StatelessWidget {
  final String userId;

  DocAppointmentHistory({required this.userId});
  Future<List<Map<String, dynamic>>> fetchSentAppointments() async {
    print("Fetching sent appointments for userId: $userId");

    final userAppointments = await FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: userId)
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
            return Center(child: Text("No appointments found."));
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
                          "${appointment['patientName'] ?? 'N/A'}",
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
              // return Card(
              //   margin: EdgeInsets.all(10),
              //   child: Padding(
              //     padding: const EdgeInsets.all(15),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //             "Patient Name: ${appointment['patientName'] ?? 'N/A'}",
              //             style: TextStyle(fontWeight: FontWeight.bold)),
              //         Text("Mobile: ${appointment['mobile'] ?? 'N/A'}"),
              //         Text("Date: ${appointment['date'] ?? 'N/A'}"),
              //         Text("Time: ${appointment['time'] ?? 'N/A'}"),
              //         Text(
              //             "Description: ${appointment['description'] ?? 'N/A'}"),
              //       ],
              //     ),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
