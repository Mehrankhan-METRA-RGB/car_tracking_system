import 'dart:convert';

class Instruction {
  Instruction({this.id, this.message, this.dateTime, this.fromAdmin});
  final String? id;
  final String? message;
  final bool? fromAdmin;
  final String? dateTime;

  Instruction copyWith(
          {String? id, String? dateTime, String? message, bool? fromAdmin}) =>
      Instruction(
          id: id ?? this.id,
          message: message ?? this.message,
          fromAdmin: fromAdmin ?? this.fromAdmin,
          dateTime: dateTime ?? this.dateTime);

  factory Instruction.fromJson(String str) =>
      Instruction.fromMap(json.decode(str));
  factory Instruction.fromMap(Map<String?, dynamic> map) => Instruction(
        id: map['id'],
        message: map['message'],
        fromAdmin: map['fromAdmin'],
        dateTime: map['dateTime'],
      );

  Map<String, dynamic> toMap() =>
      {'id': id, 'message': message,
        'fromAdmin': fromAdmin,
        'dateTime': dateTime
      };
  String toJson() => json.encode(toMap());
}
