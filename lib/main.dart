import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tvst/authentication/view/login_screen.dart';
import 'package:tvst/consts/theme.dart';
import 'package:tvst/firebase_options.dart';
import 'package:tvst/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  var client = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TikTok Clone',
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      home: client != null ? HomeScreen() : LoginScreen(),
    );
  }
}
