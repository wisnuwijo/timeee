import 'package:flutter/material.dart';
import 'package:timey/modules/auth/login.dart';
import 'package:timey/modules/auth/register.dart';

class Auth extends StatefulWidget {
  Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Selamat datang di Timeee"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Register())), 
              child: Text("Register")
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Login())), 
              child: Text("Login")
            )
          ],
        ),
      ),
    );
  }
}