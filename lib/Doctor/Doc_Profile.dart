import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthapp/Doctor/Doc_Appointment_History.dart';
import 'package:healthapp/Doctor/Edit_Profile.dart';
import 'package:healthapp/Widget/Appointment_History.dart';

class DocProfile extends StatelessWidget {
  final String userid;
  DocProfile({required this.userid});
  final currentUser = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('uid', isEqualTo: currentUser.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No data available"),
              );
            } else if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var data = docs[index].data();

                  return Container(
                    child: Column(
                      children: [
                        Container(
                          height: 510,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Container(
                                child: Stack(
                                  children: [
                                    Positioned(
                                        right: 15,
                                        top: 30,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProfile(),
                                                  ));
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              size: 21,
                                              color: Colors.white,
                                            ))),
                                  ],
                                ),
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.1, 0.5],
                                    colors: [
                                      Colors.indigo,
                                      Colors.indigoAccent,
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 123,
                                top: 90,
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(120)),
                                  child: Center(
                                    child: Container(
                                      height: 110,
                                      width: 110,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(data[
                                                      'profileImageUrl'] ??
                                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(110)),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  left: 162,
                                  top: 210,
                                  child: Text(
                                    data['name'] ?? "",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  )),
                              Positioned(
                                  left: 162,
                                  top: 240,
                                  child: Text(
                                    data['profession'] ?? "",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Positioned(
                                left: 15,
                                right: 15,
                                top: 300,
                                child: Container(
                                  child: Column(
                                    children: [
                                      Gap(15),
                                      Row(
                                        children: [
                                          Gap(10),
                                          Container(
                                            height: 25,
                                            width: 25,
                                            child: Center(
                                              child: Icon(
                                                Icons.mail,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: const Color.fromARGB(
                                                  255, 186, 17, 5),
                                            ),
                                          ),
                                          Gap(10),
                                          Text(
                                            data['mail'] ?? "",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      Gap(10),
                                      Row(
                                        children: [
                                          Gap(10),
                                          Container(
                                            height: 25,
                                            width: 25,
                                            child: Center(
                                              child: Icon(
                                                Icons.call,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.blue[700]),
                                          ),
                                          Gap(10),
                                          Text(
                                            data['number'] ?? "",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  height: 90,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              Positioned(
                                left: 15,
                                right: 15,
                                top: 405,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Gap(14),
                                      Row(
                                        children: [
                                          Gap(10),
                                          Container(
                                            height: 25,
                                            width: 25,
                                            child: Center(
                                              child: Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.blue[900]),
                                          ),
                                          Gap(10),
                                          Text(
                                            "Bio",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 45),
                                        child: Text(
                                          data['bio'] ?? "",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                  height: 90,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Container(
                            child: Column(
                              children: [
                                Gap(16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        width: 163,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              child: Center(
                                                child: Icon(
                                                  Icons.history,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: Colors.green[900]),
                                            ),
                                            Gap(10),
                                            Text(
                                              "Appointment History",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 15, right: 15),
                                  child: Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 5, right: 5),
                                        child: DocAppointmentHistory(
                                          userId: userid,
                                        )),
                                    height: 240,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            height: 310,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                          ),
                        ),
                        Gap(30),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Text("No data Found");
            }
          },
        ));
  }
}
