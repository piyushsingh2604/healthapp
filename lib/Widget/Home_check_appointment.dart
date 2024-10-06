import 'package:flutter/material.dart';
import 'package:healthapp/Screens/AppointmentScreen.dart';

class HomeCheckAppointment extends StatelessWidget {
  final String uid;
  HomeCheckAppointment({required this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 900,
              child: Appointmentscreen(userid: uid),
            )
          ],
        ),
      ),
    );
  }
}
