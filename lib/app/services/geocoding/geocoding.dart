import 'package:dio/dio.dart';
import 'package:timey/app/services/geocoding/model/location_detail.dart';
import 'dart:math' as math;

class Geocoding {

  static Future<LocationDetail> reverse(double lat, double lng) async {
    late LocationDetail address;
    try {
      var response = await Dio().get('https://us1.locationiq.com/v1/reverse.php?key=6f42be22efaf4a&lat=$lat&lon=$lng&format=json');
      print(response);

      address = LocationDetail.fromJson(response.data);
    } catch (e) {
      print(e);
    }

    return address;
  }

  double getDistanceFromLatLonInMetre(double lat1, double lon1,double lat2, double lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = _deg2rad(lat2-lat1);  // deg2rad below
    var dLon = _deg2rad(lon2-lon1); 
    var a = 
      math.sin(dLat/2) * math.sin(dLat/2) +
      math.cos(_deg2rad(lat1)) * math.cos(_deg2rad(lat2)) * 
      math.sin(dLon/2) * math.sin(dLon/2);

    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a)); 
    var d = R * c; // Distance in km
    return d/1000; // convert distance in m
  }

  double _deg2rad(deg) {
    return deg * (math.pi / 180);
  }
}