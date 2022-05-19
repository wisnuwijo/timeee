// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timey/app/services/attendance/attendance_service.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with AfterLayoutMixin<Settings>{

  bool? _isAdmin;
  TextEditingController _maxRadiusController = TextEditingController();
  TextEditingController _officeLat = TextEditingController();
  TextEditingController _officeLong = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_isAdmin != null && _isAdmin == false) return const Center(child: Text("Anda tidak memiliki akses"));
    // ignore: curly_braces_in_flow_control_structures
    if (_isAdmin != null && _isAdmin!) return Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        ListTile(
          onTap: () {},
          title: const Text("Maks. radius absensi (meter)"),
          trailing: SizedBox(
            width: 100,
            child: FutureBuilder(
              future: AttendanceService.getMaxRadius(),
              builder: (context, snapshot) {
                _maxRadiusController.text = snapshot.data.toString();
                return snapshot.hasData
                  ? TextFormField(
                    controller: _maxRadiusController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true, 
                      border: UnderlineInputBorder()
                    )
                  )
                  : const Text("Memuat ...");
              },
            ),
          ),
        ),
        Divider(height: 1),
        ListTile(
          onTap: () {},
          title: const Text("Latitude titik utama"),
          trailing: SizedBox(
            width: 100,
            child: FutureBuilder(
              future: AttendanceService.getOfficeLat(),
              builder: (context, lat) {
                _officeLat.text = lat.data.toString();
                return lat.hasData
                  ? TextFormField(
                    controller: _officeLat,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true, 
                      border: UnderlineInputBorder()
                    )
                  )
                  : const Text("Memuat ...");
              },
            ),
          ),
        ),
        Divider(height: 1),
        ListTile(
          onTap: () {},
          title: const Text("Longitude titik utama"),
          trailing: SizedBox(
            width: 100,
            child: FutureBuilder(
              future: AttendanceService.getOfficeLong(),
              builder: (context, long) {
                _officeLong.text = long.data.toString();
                return long.hasData
                  ? TextFormField(
                    controller: _officeLong,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true, 
                      border: UnderlineInputBorder()
                    )
                  )
                  : const Text("Memuat ...");
              },
            ),
          ),
        ),
        TextButton(
          child: const Text("Simpan"),
          onPressed: () async {
            showDialog(
              context: context, 
              builder: (BuildContext context) {
                return const AlertDialog(
                  content: Text("Memperbarui pengaturan ..."),
                );
              }
            );

            await AttendanceService.updateSettings(int.parse(_maxRadiusController.text), _officeLat.text, _officeLong.text);

            Navigator.pop(context);
            showDialog(
              context: context, 
              builder: (BuildContext context) {
                return const AlertDialog(
                  content: Text("Berhasil diperbarui"),
                );
              }
            );
          }
        )
      ],
    );

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_isAdmin != true) {
      setState(() {
        _isAdmin = prefs.getBool("is_admin");
      });
    }
  }
}