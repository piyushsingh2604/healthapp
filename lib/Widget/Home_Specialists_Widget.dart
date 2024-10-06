import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthapp/Screens/AboutScreen.dart';

class HomeSpecialistsWidget extends StatelessWidget {
  final String uid;
  HomeSpecialistsWidget({required this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSpecialistContainer(context, 'Cardiologist',
              'https://gentem.com/wp-content/uploads/2022/07/cardiology-cheat-sheet-blog-graphic.png'),
          Gap(10),
          _buildSpecialistContainer(context, 'Dentist',
              'https://static.vecteezy.com/system/resources/thumbnails/018/245/406/small_2x/icon-with-dentist-s-tools-and-a-blue-shield-png.png'),
          Gap(10),
          _buildSpecialistContainer(context, 'Eye Specialist',
              'https://cdn-icons-png.flaticon.com/512/5717/5717736.png'),
          Gap(10),
          _buildSpecialistContainer(context, 'Allergist',
              'https://cdn-icons-png.flaticon.com/512/2248/2248412.png'),
          Gap(10),
          _buildSpecialistContainer(context, 'Orthopaedist',
              'https://i0.wp.com/griportho.com/wp-content/uploads/2021/11/GRIPORTHO-SYMBOL.png'),
          Gap(10),
        ],
      ),
    );
  }

  Widget _buildSpecialistContainer(
      BuildContext context, String profession, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorListScreen(
              profession: profession,
              uid: uid,
            ),
          ),
        );
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                child: Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                ),
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(245, 255, 255, 255),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
            Gap(5),
            Text(
              profession,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: _getColorForProfession(profession),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Color _getColorForProfession(String profession) {
    switch (profession.toLowerCase()) {
      case 'cardiologist':
        return Color(0xFFEC407A);
      case 'dentist':
        return Color(0xFF5C6BC0);
      case 'eye specialist':
        return Color(0xFFFBC02D);
      case 'allergist':
        return Color(0xFF1565C0);
      case 'orthopaedist':
        return Color(0xFF5C6BC0);
      default:
        return Colors.grey;
    }
  }
}

class DoctorListScreen extends StatelessWidget {
  final String profession;
  final String uid;

  const DoctorListScreen(
      {super.key, required this.profession, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$profession Doctors'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs.where((user) {
            var data = user.data();
            return data['profession'] == profession;
          }).toList();

          if (docs.isEmpty) {
            return Center(child: Text('No doctors found for this profession.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final user = docs[index];
              final userid = user.id;
              var data = user.data();
              return ListTile(
                title: Text(data['name'] ?? ''),
                subtitle: Text(data['profession'] ?? ''),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Aboutscreen(
                          userid: userid,
                          currentid: uid,
                        ),
                      ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
