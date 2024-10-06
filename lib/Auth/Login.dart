import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthapp/Auth/Forget.dart';
import 'package:healthapp/Auth/SighUp.dart';
import 'package:healthapp/Doctor/Doc_BottomBar.dart';
import 'package:healthapp/Screens/Home_Screen.dart';
import 'package:healthapp/Widget/BottomBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _mail = TextEditingController();
  TextEditingController _pass = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> onLogIn() async {
    String mail = _mail.text.trim();
    String pass = _pass.text.trim();

    // Check if fields are empty
    if (mail.isEmpty || pass.isEmpty) {
      showAlertDialog(
          "Fields cannot be empty", "Please enter your email and password.");
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: pass);

      String uid = userCredential.user!.uid;

      // Fetch user document from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();

      if (userDoc.exists) {
        String username = userDoc["name"];

        // Cast userDoc.data() to Map<String, dynamic>
        final userData = userDoc.data() as Map<String, dynamic>;

        if (userData.containsKey('UserType')) {
          String userType = userData['UserType'];

          // Navigate based on userType
          if (userType == 'user') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BottomNavBar(userid: uid, name: username),
                ));
          } else if (userType == 'doctor') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DocBottomNavBar(userid: uid),
                ));
          }
        } else {
          showAlertDialog("Error", "User type not found in document.");
        }
      } else {
        showAlertDialog("Error", "User document does not exist");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'wrong-password') {
        errorMessage = "The password is wrong.";
      } else {
        errorMessage = "An error occurred. Please try again.";
      }
      showAlertDialog("Error", errorMessage);
    } catch (e) {
      showAlertDialog("Error", "An unexpected error occurred: $e");
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
          if (_isLoading) // Show loading indicator if logging in
            Center(
              child: CircularProgressIndicator(),
            ),
          Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(40),
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/login.png'),
                            fit: BoxFit.cover)),
                    height: 170,
                    width: 290,
                  ),
                  Gap(30),
                  Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: TextFormField(
                          autocorrect: true,
                          controller: _mail,
                          cursorHeight: 16,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey,
                                ),
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
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo[900],
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 50)),
                        onPressed: () {
                          onLogIn();
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                  ),
                  Gap(10),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                            ));
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      )),
                  Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ));
                          },
                          child: Text(
                            "Signup here",
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
        ],
      ),
    );
  }
}
