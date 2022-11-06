
import 'package:meta/meta.dart';
import 'dart:convert';

class Company {
  Company({
    @required this.name,
    @required this.biography,
    @required this.license,
    @required this.phone,
    @required this.email,
    @required this.points,
    @required this.password,
    @required this.id,
  });

  final String? name;
  final String? biography;
  final String? license;
  final String? email;
  final String? phone;
  final String? password;
  final List<double>? points;
  final String? id;

  Company copyWith({
    String? name,
    String? biography,
    String? license,
    String? phone,
    String? email,
    String? password,
    List<double>? points,
    String? id,
  }) =>
      Company(
        name: name ?? this.name,
        biography: biography ?? this.biography,
        license: license ?? this.license,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        password: password ?? this.password,

        points: points ?? this.points,
        id: id ?? this.id,
      );

  factory Company.fromJson(String str) => Company.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Company.fromMap(Map<String?, dynamic> json) => Company(
    name: json["name"],
    biography: json["biography"],
    license: json["license"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
    points: List<double>.from(json["points"].map((x) => x.toDouble())),
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "biography": biography,
    "license": license,
    "email": email,
    "phone": phone,
    "points": List<dynamic>.from(points!.map((x) => x)),
    "id": id,
    "password":password
  };


}
