class LocationDetail {
  String? placeId;
  String? licence;
  String? osmType;
  String? osmId;
  String? lat;
  String? lon;
  String? displayName;
  Address? address;
  List<String>? boundingbox;

  LocationDetail(
      {this.placeId,
      this.licence,
      this.osmType,
      this.osmId,
      this.lat,
      this.lon,
      this.displayName,
      this.address,
      this.boundingbox});

  LocationDetail.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    licence = json['licence'];
    osmType = json['osm_type'];
    osmId = json['osm_id'];
    lat = json['lat'];
    lon = json['lon'];
    displayName = json['display_name'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    boundingbox = json['boundingbox'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['place_id'] = this.placeId;
    data['licence'] = this.licence;
    data['osm_type'] = this.osmType;
    data['osm_id'] = this.osmId;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['display_name'] = this.displayName;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['boundingbox'] = this.boundingbox;
    return data;
  }
}

class Address {
  String? hotel;
  String? road;
  String? cityBlock;
  String? neighbourhood;
  String? suburb;
  String? cityDistrict;
  String? city;
  String? postcode;
  String? country;
  String? countryCode;

  Address(
      {this.hotel,
      this.road,
      this.cityBlock,
      this.neighbourhood,
      this.suburb,
      this.cityDistrict,
      this.city,
      this.postcode,
      this.country,
      this.countryCode});

  Address.fromJson(Map<String, dynamic> json) {
    hotel = json['hotel'];
    road = json['road'];
    cityBlock = json['city_block'];
    neighbourhood = json['neighbourhood'];
    suburb = json['suburb'];
    cityDistrict = json['city_district'];
    city = json['city'];
    postcode = json['postcode'];
    country = json['country'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel'] = this.hotel;
    data['road'] = this.road;
    data['city_block'] = this.cityBlock;
    data['neighbourhood'] = this.neighbourhood;
    data['suburb'] = this.suburb;
    data['city_district'] = this.cityDistrict;
    data['city'] = this.city;
    data['postcode'] = this.postcode;
    data['country'] = this.country;
    data['country_code'] = this.countryCode;
    return data;
  }
}
