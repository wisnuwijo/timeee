// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timey/modules/home/home.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _registerFormState = GlobalKey<FormState>();

  void _registerUser() async {
    print("registering user ...");
    late UserCredential _registerUser;
    try {
      _registerUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text, password: _password.text);

      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setBool("is_admin", false);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      print("register failed : " + e.toString());
      if (e.toString() == "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('Gagal'),
                content: Text("Email sudah digunakan pengguna lain"),
              );
            });

        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _registerFormState,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(label: Text("Email")),
                  validator: (value) {
                    if (value!.isEmpty) return "Harus diisi";
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: _password,
                  decoration: InputDecoration(label: Text("Password")),
                  validator: (value) {
                    if (value!.isEmpty) return "Harus diisi";
                  },
                ),
                TextButton(
                  onPressed: () => _registerUser(), 
                  child: const Text("Daftar")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
