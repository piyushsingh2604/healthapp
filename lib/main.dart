import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/Auth/Login.dart';
import 'package:healthapp/Auth/StartScreen.dart';
import 'package:healthapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();
  final List<Map<String, String>> notifications = [];

  @override
  Widget build(BuildContext context) {
    _firebaseService.initialize();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      // routes: {
      //   '/userHome': (context) => UserHomeScreen(),
      //   '/doctorHome': (context) => DoctorHomeScreen(),
      // },
    );
  }
}

//https://github.com/sailesh307/health_app

// todo list

// notification

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final List<Map<String, String>> notifications =
      []; // List to store notifications

  Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get the token for the device
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message while in the foreground!');
      // Store the notification
      _handleMessage(message);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _handleMessage(RemoteMessage message) {
    // Store the notification in the list
    notifications.add({
      'title': message.notification?.title ?? 'No Title',
      'body': message.notification?.body ?? 'No Body',
    });
    print('Notification stored: ${message.notification}');
  }
}

// This handler is called when the app is in the background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}
