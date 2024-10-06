import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/Screens/AboutScreen.dart';

class HomeRatedWidget extends StatelessWidget {
  String currentid;
  HomeRatedWidget({required this.currentid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final user = docs[index];
              var data = docs[index].data();
              var userid = user.id;

              if (data['name'] == null ||
                  (data['profession'] != null &&
                      data['profession']!.isNotEmpty)) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Aboutscreen(
                              userid: userid,
                              currentid: currentid,
                            ),
                          ));
                    },
                    child: Container(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 12,
                            left: 20,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(data[
                                            'profileImageUrl'] ??
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 75,
                            top: 17,
                            child: Text(
                              data['name'] ?? "",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (data['profession'] != null &&
                              data['profession']!.isNotEmpty) ...[
                            Positioned(
                              left: 75,
                              top: 35,
                              child: Text(
                                data['profession']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      height: 65,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(167, 187, 222, 251),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                );
              } else {
                // If no valid name or profession, return an empty container
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
