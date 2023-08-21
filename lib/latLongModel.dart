// To parse this JSON data, do
//
//     final latLongResponseModel = latLongResponseModelFromJson(jsonString);

import 'dart:convert';

List<LatLongResponseModel> latLongResponseModelFromJson(String str) => List<LatLongResponseModel>.from(json.decode(str).map((x) => LatLongResponseModel.fromJson(x)));

String latLongResponseModelToJson(List<LatLongResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LatLongResponseModel {
  String lat;
  String long;

  LatLongResponseModel({
    required this.lat,
    required this.long,
  });

  factory LatLongResponseModel.fromJson(Map<String, dynamic> json) => LatLongResponseModel(
    lat: json["lat"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "long": long,
  };
}
