import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthapp/Screens/AppointmentScreen.dart';
import 'package:healthapp/Screens/Search.dart';
import 'package:healthapp/Widget/Home_Rated_Widget.dart';
import 'package:healthapp/Widget/Home_check_appointment.dart';

class HomeCareWidget extends StatelessWidget {
  final String uid;
  HomeCareWidget({required this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(id: uid),
                  ));
            },
            child: Container(
              height: 130,
              width: 305,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 188, 231, 253),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 7, top: 5, bottom: 5),
                    child: Container(
                      height: 130,
                      width: 100,
                      child: Image.asset(
                        'assets/healthCheckup_first.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 110, bottom: 67),
                    child: Text(
                      "Top Doctors >",
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(15),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeCheckAppointment(uid: uid),
                  ));
            },
            child: Container(
              height: 130,
              width: 305,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 188, 231, 253),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 7, top: 5, bottom: 5),
                    child: Container(
                      height: 130,
                      width: 100,
                      child: Image.asset(
                        'assets/medical-check-up-consultations-illustration-download-in-svg-png-gif-file-formats--free-checkup-consultation-camp-charity-pack-business-illustrations-6508184.webp',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 75, bottom: 67),
                    child: Text(
                      "Check Appointment >",
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(15),
        ],
      ),
    );
  }
}
