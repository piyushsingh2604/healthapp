import 'package:flutter/material.dart';
import 'package:healthapp/Widget/Patient_Appointment_Widget.dart';

class Appointmentscreen extends StatelessWidget {
  final String userid;
  Appointmentscreen({required this.userid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 5,
        title: Text(
          "My Appointments",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 600,
              width: MediaQuery.of(context).size.width,
              child: PatientAppointmentWidget(
                userId: userid,
              ),
            )
          ],
        ),
      ),
    );
  }
}
