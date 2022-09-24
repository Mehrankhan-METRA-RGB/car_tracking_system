import 'package:meta/meta.dart';
import 'dart:convert';

class Driver {
  Driver({
    @required this.driverName,
    @required this.id,
    @required this.driverPhone,
    @required this.vehicleName,
    @required this.vehicleRegNo,
    @required this.vehicleChassis,
    @required this.permanentPoints,
    @required this.destinationPoints,
    @required this.nextPoints,
    @required this.companyId,
  });

  final String? id;
  final String? driverName;
  final String? driverPhone;
  final String? vehicleName;
  final String? vehicleRegNo;
  final String? vehicleChassis;
  final List<double>? permanentPoints;
  final List<double>? destinationPoints;
  final List<double>? nextPoints;
  final String? companyId;

  Driver copyWith({
    String? id,
    String? driverName,
    String? driverPhone,
    String? vehicleName,
    String? vehicleRegNo,
    String? vehicleChassis,
    List<double>? permanentPoints,
    List<double>? destinationPoints,
    List<double>? nextPoints,
    String? companyId,
  }) =>
      Driver(
        id: id ?? this.id,
        driverName: driverName ?? this.driverName,
        driverPhone: driverPhone ?? this.driverPhone,
        vehicleName: vehicleName ?? this.vehicleName,
        vehicleRegNo: vehicleRegNo ?? this.vehicleRegNo,
        vehicleChassis: vehicleChassis ?? this.vehicleChassis,
        permanentPoints: permanentPoints ?? this.permanentPoints,
        destinationPoints: destinationPoints ?? this.destinationPoints,
        nextPoints: nextPoints ?? this.nextPoints,
        companyId: companyId ?? this.companyId,
      );

  factory Driver.fromJson(String str) => Driver.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Driver.fromMap(Map<String, dynamic> json) => Driver(
        id: json["id"],
        driverName: json["driverName"],
        driverPhone: json["driverPhone"],
        vehicleName: json["vehicleName"],
        vehicleRegNo: json["vehicleRegNo"],
        vehicleChassis: json["vehicleChassis"],
        permanentPoints:
            List<double>.from(json["permanentPoints"].map((x) => x.toDouble())),
        destinationPoints: List<double>.from(
            json["destinationPoints"].map((x) => x.toDouble())),
        nextPoints:
            List<double>.from(json["nextPoints"].map((x) => x.toDouble())),
        companyId: json["companyId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "driverName": driverName,
        "driverPhone": driverPhone,
        "vehicleName": vehicleName,
        "vehicleRegNo": vehicleRegNo,
        "vehicleChassis": vehicleChassis,
        "permanentPoints": List<dynamic>.from(permanentPoints!.map((x) => x)),
        "destinationPoints":
            List<dynamic>.from(destinationPoints!.map((x) => x)),
        "nextPoints": List<dynamic>.from(nextPoints!.map((x) => x)),
        "companyId": companyId,
      };
}
