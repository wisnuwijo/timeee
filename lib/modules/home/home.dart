// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timey/modules/attendance/check_out.dart';
import 'package:timey/modules/auth/auth.dart';
import 'package:timey/modules/home/history.dart';
import 'package:timey/modules/home/settings.dart';
import '../attendance/check_in.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Future<User> _userDetail;
  int _selectedIndex = 0;
  String _activeTab = "Timeee";

  @override
  void initState() {
    _userDetail = Future.delayed(const Duration(seconds: 1)).then((value) {
      return FirebaseAuth.instance.currentUser!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(_activeTab),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white)
              ),
              onPressed: () => _logOut(), 
              child: const Text("Keluar")
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Histori',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Pengaturan',
            )
          ],
        ),
        body: FutureBuilder(
          future: _userDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _mainWidget(snapshot.data as User);
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) _activeTab = "Timeee";
      if (index == 1) _activeTab = "Histori";
      if (index == 2) _activeTab = "Pengaturan";
      _selectedIndex = index;
    });
  }

  void _logOut() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Auth()));
  }

  _mainWidget(User usrData) {
    // ignore: curly_braces_in_flow_control_structures
    if (_selectedIndex == 0) return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              children: [
                const Icon(Icons.person_rounded, color: Colors.white),
                const SizedBox(width: 10.0),
                Text(usrData.email.toString(), style: const TextStyle(color: Colors.white),)
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CheckIn())), 
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text("Check In"),
                ],
              ),
            )
          ),
          Divider(height: 1),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut())),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text("Check Out"),
                ],
              ),
            )
          )
        ],
      )
    );

    if (_selectedIndex == 1) return const History();
    return const Settings();
  }
}