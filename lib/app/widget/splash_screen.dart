import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timey/modules/auth/auth.dart';
import 'package:timey/modules/home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin<SplashScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Material(child: Center(child: Text("Timeee")));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Auth())));
      } else {
        print('User is signed in!');
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home())));
      }
    });
  }
}