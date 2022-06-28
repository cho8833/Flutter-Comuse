import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:json_annotation/json_annotation.dart';
part 'History.g.dart';

@JsonSerializable()
class History {
  History({
    required this.date,
    required this.name,
    required this.isEntered,
    required this.email,
    required this.epoch,
    required this.year,
    required this.month,
    required this.day,
  });

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryToJson(this);

  DateTime date;
  int epoch;
  String name;
  bool isEntered;
  String email;
  int month;
  int year;
  int day;
  factory History.fromData(DataSnapshot element) {
    Map<String, dynamic> data = jsonDecode(jsonEncode(element.value));
    DateTime? date;
    int epoch = 0;
    String name = "";
    bool isEntered = false;
    String email = "";
    int month = 0;
    int year = 0;
    int day = 0;

    try {
      epoch = data['epoch'];
    } catch (e) {}
    try {
      name = data['name'];
    } catch (e) {}
    try {
      email = data['email'];
    } catch (e) {}
    try {
      isEntered = data['isEntered'];
    } catch (e) {}
    date = DateTime.fromMillisecondsSinceEpoch(epoch);
    month = date.month;
    year = date.year;
    day = date.day;
    return History(
        date: date,
        epoch: epoch,
        name: name,
        isEntered: isEntered,
        email: email,
        month: month,
        year: year,
        day: day);
  }
}
