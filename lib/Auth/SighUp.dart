import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthapp/Auth/Login.dart';
import 'package:healthapp/Doctor/Doc_BottomBar.dart';
import 'package:healthapp/Screens/Home_Screen.dart';
import 'package:healthapp/Widget/BottomBar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _name = TextEditingController();
  TextEditingController _mail = TextEditingController();
  TextEditingController _pass = TextEditingController();
  String _userType = '';
  bool _isLoading = false; // Loading indicator flag

  final _key = GlobalKey<FormState>();

  Future<void> onSignUp() async {
    String name = _name.text.trim();
    String mail = _mail.text.trim();
    String pass = _pass.text.trim();

    // Validate fields
    if (name.isEmpty || mail.isEmpty || pass.isEmpty || _userType.isEmpty) {
      showAlertDialog("Input Error", "Please fill in all fields.");
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: pass);
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'name': name,
        "mail": mail,
        "uid": uid,
        "UserType": _userType,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sign Up complete")));

      // Navigate based on userType
      if (_userType == 'user') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(userid: uid, name: name),
            ));
      } else if (_userType == 'doctor') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DocBottomNavBar(userid: uid),
            ));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = "The password is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The email is already taken by another account.";
      } else {
        errorMessage = "An error occurred. Please try again.";
      }
      showAlertDialog("Signup Error", errorMessage);
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  void showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isLoading) // Show loading indicator if signing up
            Center(
              child: CircularProgressIndicator(),
            ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(50),
                    Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 40, left: 20, right: 20),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: TextFormField(
                            controller: _name,
                            cursorHeight: 16,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Colors.grey,
                                ),
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: TextFormField(
                            controller: _mail,
                            cursorHeight: 16,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey,
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: TextFormField(
                            controller: _pass,
                            obscureText: true,
                            cursorHeight: 16,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey,
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                _userType = 'doctor';
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  backgroundColor: Colors.grey[350],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  )),
                              child: Text(
                                "Doctor",
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                'or',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                _userType = 'user';
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: Colors.grey[350],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              child: Text(
                                "Patient",
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo[900],
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 50)),
                          onPressed: () async {
                            await onSignUp(); // Call the signup method
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          )),
                    ),
                    Gap(20),
                    Divider(
                      indent: 20,
                      endIndent: 20,
                      color: Colors.grey[400],
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ));
                            },
                            child: Text(
                              "Login here",
                              style: TextStyle(
                                  color: Colors.indigo[900],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
