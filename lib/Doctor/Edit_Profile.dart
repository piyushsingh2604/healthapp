import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController number = TextEditingController();
  TextEditingController pro = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController time = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        number.text = userData['number'] ?? '';
        bio.text = userData['bio'] ?? '';
        pro.text = userData['profession'] ?? '';
        location.text = userData['location'] ?? '';
        time.text = userData['time'] ?? '';
        // Optionally load existing image URL if needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 21,
          ),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(50),
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(120),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null),
                child: _selectedImage == null
                    ? Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 30,
                      )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: TextField(
                  controller: number,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: "Your Number",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: TextField(
                  controller: bio,
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Bio",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: TextField(
                  controller: pro,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Your Professions",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: TextField(
                  controller: location,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Your Location",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: TextField(
                  controller: time,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Your Timing",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[900],
                      minimumSize: Size(MediaQuery.of(context).size.width, 50)),
                  onPressed: editButton,
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> editButton() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      Map<String, dynamic> userData = {};

      // Only update the fields that have changed
      if (number.text.isNotEmpty) {
        userData['number'] = number.text;
      }
      if (bio.text.isNotEmpty) {
        userData['bio'] = bio.text;
      }
      if (pro.text.isNotEmpty) {
        userData['profession'] = pro.text;
      }
      if (location.text.isNotEmpty) {
        userData['location'] = location.text;
      }
      if (time.text.isNotEmpty) {
        userData['time'] = time.text;
      }

      String? imageUrl;
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${currentUser.uid}.jpg');

        try {
          await storageRef.putFile(_selectedImage!);
          imageUrl = await storageRef.getDownloadURL();
          userData['profileImageUrl'] = imageUrl; // Add image URL to data
        } catch (e) {
          print('Failed to upload image: $e');
          return;
        }
      }

      if (userData.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .update(userData)
            .then((_) {
          print('User profile updated successfully');
          // Optionally show a success message
        }).catchError((error) {
          print('Failed to update profile: $error');
        });
      } else {
        print('No changes made to update');
      }
    }
  }
}
