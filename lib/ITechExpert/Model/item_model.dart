import 'package:meta/meta.dart';
import 'dart:convert';

class Item {
  Item({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.image,
  });

  final int? id;
  final String? title;
  final String? price;
  final String? image;

  Item copyWith({
    int? id,
    String? title,
    String? price,
    String? image,
  }) =>
      Item(
        id: id ?? this.id,
        title: title ?? this.title,
        price: price ?? this.price,
        image: image ?? this.image,
      );

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
    id: json["id"],
    title: json["title"],
    price: json["price"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "price": price,
    "image": image,
  };
}
