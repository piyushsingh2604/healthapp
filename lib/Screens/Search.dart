import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/Screens/AboutScreen.dart';

class SearchScreen extends StatefulWidget {
  final String id;
  SearchScreen({required this.id});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<User> doctors = [];
  List<User> filteredDoctors = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('UserType', isEqualTo: 'doctor')
          .get();

      setState(() {
        doctors = snapshot.docs
            .map(
                (doc) => User.fromFirestore(doc.data() as Map<String, dynamic>))
            .where((user) => user.name.isNotEmpty)
            .toList();
        filteredDoctors = doctors; // Initialize with all doctors
      });
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }

  void filterDoctors(String query) {
    final filtered = doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(query.toLowerCase()) ||
          doctor.profession.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchQuery = query;
      filteredDoctors = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Doctor Search'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterDoctors,
              decoration: InputDecoration(
                hintText: 'Search by name or profession',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: filteredDoctors.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return ListTile(
                  title: Text(doctor.name),
                  subtitle: Text(doctor.profession),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(doctor.profileImageUrl),
                  ),
                  onTap: () {
                    // Navigate to Doctor Details Screen using UID
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Aboutscreen(
                          currentid: widget.id,
                          userid: doctor.uid,
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

class User {
  final String uid;
  final String name;
  final String profession;
  final String bio;
  final String location;
  final String mail;
  final String number;
  final String time;
  final String profileImageUrl;

  User({
    required this.uid,
    required this.name,
    required this.profession,
    required this.bio,
    required this.location,
    required this.mail,
    required this.number,
    required this.time,
    required this.profileImageUrl,
  });

  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      uid: data['uid'] ?? '', // Provide a default value if null
      name: data['name'] ?? '',
      profession: data['profession'] ?? '',
      bio: data['bio'] ?? '',
      location: data['location'] ?? '',
      mail: data['mail'] ?? '',
      number: data['number'] ?? '',
      time: data['time'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '', // Provide a default value
    );
  }
}
