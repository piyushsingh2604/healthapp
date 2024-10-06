import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthapp/Screens/Notification.dart';
import 'package:healthapp/Screens/ProfileScreen.dart';
import 'package:healthapp/Screens/Search.dart';
import 'package:healthapp/Widget/Home_Care_Widget.dart';
import 'package:healthapp/Widget/Home_Rated_Widget.dart';
import 'package:healthapp/Widget/Home_Specialists_Widget.dart';
import 'package:healthapp/main.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final String uid;
  HomeScreen({required this.name, required this.uid});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 210,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    top: 45,
                    right: 10,
                    child: Container(
                      width: 160,
                      height: 26,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Good Morning",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Notifications(),
                                    ));
                              },
                              icon: Icon(
                                Icons.notifications_active,
                                color: Colors.black,
                                size: 19,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 100,
                      left: 20,
                      child: Text(
                        "Hello ${widget.name}",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      )),
                  Positioned(
                    top: 130,
                    left: 20,
                    child: Container(
                      width: 140,
                      child: Text(
                        "Let's Find Your Doctor",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 4),
                      child: Container(
                        width: 200,
                        child: TextField(
                          readOnly: true,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SearchScreen(id: widget.uid),
                                ));
                          },
                          cursorHeight: 16,
                          decoration: InputDecoration(
                            hintText: 'Search doctor',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(173, 26, 34, 126),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(116, 189, 189, 189)),
                height: 40,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "We care for you",
                style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 45, top: 10),
              child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: HomeCareWidget(
                    uid: widget.uid,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "Specialists",
                style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: HomeSpecialistsWidget(
                    uid: widget.uid,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Top Rated",
                style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: HomeRatedWidget(
                  currentid: widget.uid,
                ),
              ),
            ),
            Gap(30),
          ],
        ),
      ),
    );
  }
}
