// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:timey/app/services/attendance/attendance_service.dart';
import 'package:timey/app/services/geocoding/geocoding.dart';
import 'package:timey/app/services/geocoding/model/location_detail.dart';

class CheckIn extends StatefulWidget {
  CheckIn({Key? key}) : super(key: key);

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {

  LocationData _locationLatLng = LocationData.fromMap({
    "latitude": 0.0,
    "longitude": 0.0
  });

  String _locationAddress = "";
  // ignore: prefer_final_fields
  bool _loading = false;

  _convertLatLngToAddress() async {
    LocationDetail _getLocationDetail = await Geocoding.reverse(_locationLatLng.latitude!, _locationLatLng.longitude!);
    setState(() {
      _locationAddress = _getLocationDetail.displayName!;
    });
  }

  _getLocation() async {
    setState(() {
      _loading = true;
    });

    Location location = Location();

    late bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    late LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    
    print("lat : ${_locationData.latitude}");
    print("lng : ${_locationData.longitude}");

    setState(() {
      _locationLatLng = _locationData;
      _loading = false;
    });

    await _convertLatLngToAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Check In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(),
            const Text("Lokasi : "),
            const Divider(),
            Text( _locationAddress == "" ? "Silahkan tap Cari Lokasi untuk memulai" : _locationAddress, textAlign: TextAlign.center),
            const Divider(),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0)
              ),
              onPressed: () => _getLocation(), 
              child: Text(_loading ? "Memproses ..." : "Cari Lokasi")
            ),
            TextButton(
              onPressed: () async {
                // ignore: curly_braces_in_flow_control_structures
                if (_locationAddress == "") {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Pesan'),
                        content: Text("Mohon tap Cari Lokasi terlebih dahulu"),
                      );
                    }
                  );

                  return;
                }
                
                bool isMaxRadiusExceed = await AttendanceService.isMaxRadiusExceed(_locationLatLng.latitude.toString(), _locationLatLng.longitude.toString());

                if (isMaxRadiusExceed) {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Pesan'),
                        content: Text("Lokasi tempat Anda berada terlalu jauh dari titik utama. Mohon bergeser mendekati titik utama"),
                      );
                    }
                  );

                  return;
                };

                setState(() {
                  _loading = true;
                });

                await AttendanceService.attend(
                  address: _locationAddress,
                  lat: _locationLatLng.latitude.toString(),
                  long: _locationLatLng.longitude.toString(),
                  timestamp: DateTime.now().toIso8601String(),
                  type: "check_in",
                  userUid: FirebaseAuth.instance.currentUser!.uid.toString()
                );

                showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Pesan'),
                        content: Text("Check in berhasil tersimpan"),
                      );
                    }
                  );

                setState(() {
                  _loading = false;
                });
              }, 
              child: Text(_loading ? "Memproses ..." : "Simpan Check In")
            )
          ],
        ),
      ),
    );
  }
}