import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timey/modules/home/home.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();

  void _signIn() async {
    try {
      UserCredential _login = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text, password: _password.text);
    
      if (_login.user != null) {
        DocumentSnapshot<Map<String, dynamic>> _getAdminConfig = await FirebaseFirestore.instance.collection("config").doc("admin").get();
        String _adminUid = _getAdminConfig.data()!["user_uid"];
        print("admin uid : "+ _adminUid);

        SharedPreferences _prefs = await SharedPreferences.getInstance();
        print("_adminUid == _login.user?.uid : ${_adminUid == _login.user?.uid}");
        _prefs.setBool("is_admin", _adminUid == _login.user?.uid);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
      }
    } catch (e) {
      print("e : " +e.toString());
      if (e.toString() == "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
        showDialog(
          context: context, 
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Pesan'),
              content: Text("Email / sandi yang Anda masukkan salah"),
            );
          }
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _loginForm,
            child: Column(
              children: [
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    label: Text("Email")
                  ),
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
                  onPressed: () => _signIn(), 
                  child: Text("Masuk")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}