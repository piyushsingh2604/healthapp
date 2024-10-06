import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';
import 'package:healthapp/Chat/ChatScreen.dart';
import 'package:healthapp/Screens/BookingScreen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Aboutscreen extends StatelessWidget {
  final String userid;
  final String currentid;

  Aboutscreen({required this.userid, required this.currentid});

  Future<Map<String, dynamic>?> userinfo() async {
    DocumentSnapshot userdoc =
        await FirebaseFirestore.instance.collection('Users').doc(userid).get();
    return userdoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              )),
          elevation: 0,
        ),
        body: FutureBuilder(
          future: userinfo(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Handle error
            }
            if (!snapshot.hasData) {
              return Text('No data available'); // Handle empty data
            }
            final info = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10),
                  Center(
                    child: Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(info['profileImageUrl'] ??
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(130)),
                    ),
                  ),
                  Gap(10),
                  Center(
                      child: Text(
                    info['name'] ?? "",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  )),
                  Gap(3),
                  Center(
                      child: Text(
                    info['profession'] ?? "",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 50),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 21,
                          color: const Color.fromARGB(208, 0, 0, 0),
                        ),
                        Gap(15),
                        Text(info['location'] ?? "")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.call_outlined,
                          size: 21,
                          color: const Color.fromARGB(208, 0, 0, 0),
                        ),
                        Gap(15),
                        Text(
                          info['number'] ?? "",
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.av_timer_rounded,
                          size: 21,
                          color: const Color.fromARGB(208, 0, 0, 0),
                        ),
                        Gap(15),
                        Text("Working Hours")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 59, top: 14),
                    child: Row(
                      children: [
                        Text(
                          "Today:",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        Gap(10),
                        Text(
                          info['time'] ?? "",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 35),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(192, 26, 34, 126),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 50)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Bookingscreen(
                                    profileuserName: info['name'],
                                    userid: info['uid'],
                                    currentid: currentid),
                              ));
                        },
                        child: Text(
                          "Book Appointment",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                  ),
                  Center(child: Text("or")),
                  Gap(7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          launchUrlString("tel://${info['number']}");
                        },
                        child: Container(
                          child: Center(
                            child: Icon(
                              Icons.call,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                          height: 40,
                          width: 55,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(192, 26, 34, 126),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}
