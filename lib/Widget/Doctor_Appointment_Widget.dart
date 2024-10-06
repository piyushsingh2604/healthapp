import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:url_launcher/url_launcher_string.dart';

class DoctorAppointmentWidget extends StatelessWidget {
  final String userId;

  DoctorAppointmentWidget({required this.userId});

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    final userAppointments = await FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .get();

    return userAppointments.docs
        .map((doc) => {
              ...doc.data(),
              'docId': doc.id,
            } as Map<String, dynamic>)
        .toList();
  }

  Future<void> deleteAppointment(String docId) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(docId)
        .delete();
  }

  DateTime? parseDate(String dateString) {
    try {
      return DateFormat('dd MMMM yyyy').parse(dateString);
    } catch (e) {
      print('Error parsing date: $dateString');
      return null; // Return null if parsing fails
    }
  }

  String getAppointmentStatus(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // Midnight of today

    if (date.isBefore(today)) {
      return "DONE";
    } else if (date.isAtSameMomentAs(today)) {
      return "TODAY";
    } else {
      return "WAITING";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              final date = parseDate(appointment['date'] ?? '');
              final status = date != null ? getAppointmentStatus(date) : 'N/A';

              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 3,
                        color: const Color.fromARGB(85, 158, 158, 158),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 15,
                        child: Text(
                          "${appointment['patientName'] ?? 'N/A'}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 15,
                        child: Text(
                          "${appointment['date'] ?? 'N/A'}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        left: 15,
                        child: Text(
                          "Time: ${appointment['time'] ?? 'N/A'}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 90,
                        left: 15,
                        child: Row(
                          children: [
                            Text("Description:", style: TextStyle()),
                            Gap(4),
                            Text(
                              "${appointment['description'] ?? 'N/A'}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 150,
                        child: Center(
                          child: Text(
                            status,
                            style: TextStyle(
                              color: status == "DONE"
                                  ? Colors.grey
                                  : status == "TODAY"
                                      ? Colors.green
                                      : Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 76,
                        left: 280,
                        child: IconButton(
                          onPressed: () async {
                            await deleteAppointment(appointment['docId']);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 280,
                        child: IconButton(
                          onPressed: () {
                            launchUrlString("tel://${appointment['mobile']}");
                          },
                          icon: Icon(
                            Icons.call,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                      ),
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
