import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceService {

    static Future<DocumentReference<Map<String, dynamic>>> attend({
      required String address,
      required String lat,
      required String long,
      required String timestamp,
      required String type,
      required String userUid
    }) async {
      final _attendanceData = <String, dynamic>{
        "address": address,
        "lat": lat,
        "long": long,
        "timestamp": timestamp,
        "type": type,
        "user_uid": userUid
      };
      final _db = FirebaseFirestore.instance;
      
      return _db.collection("attendance").add(_attendanceData);
    }

    static Future<int> getMaxRadius() async {
      final _db = FirebaseFirestore.instance;
      DocumentSnapshot<Map<String, dynamic>> getLocationConfig = await _db.collection("config").doc("location").get();
      return getLocationConfig.data()!["max_radius"];
    }

    static Future<String> getOfficeLat() async {
      final _db = FirebaseFirestore.instance;
      DocumentSnapshot<Map<String, dynamic>> getLocationConfig = await _db.collection("config").doc("location").get();
      return getLocationConfig.data()!["lat"];
    }

    static Future<String> getOfficeLong() async {
      final _db = FirebaseFirestore.instance;
      DocumentSnapshot<Map<String, dynamic>> getLocationConfig = await _db.collection("config").doc("location").get();
      return getLocationConfig.data()!["long"];
    }

    static Future<void> updateSettings(int maxRadius, String lat, String long) async {
      final _db = FirebaseFirestore.instance;
      await _db.collection("config").doc("location").update({
        "max_radius": maxRadius,
        "lat": lat,
        "long": long
      });
    }

    static Future<bool> isMaxRadiusExceed(String lat, String long) async {
      int maxRadius = await AttendanceService.getMaxRadius();
      String officeLat = await AttendanceService.getOfficeLat();
      String officeLong = await AttendanceService.getOfficeLong();

      double distance = Geolocator.distanceBetween(double.parse(officeLat), double.parse(officeLong), double.parse(lat), double.parse(long));
      return distance > maxRadius;
    }

    static Future<List<Map<String, dynamic>>> getHistory() async {
      final _db = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> getAttendanceHistory = await _db
        .collection("attendance")
        .where("user_uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid.toString())
        .orderBy("timestamp")
        .get();

      List<Map<String, dynamic>> attendanceHistory = getAttendanceHistory.docs.map((e) => e.data()).toList();
      return attendanceHistory;
    }
}