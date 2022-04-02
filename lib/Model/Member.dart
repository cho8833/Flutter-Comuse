import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Constants/FirebaseConstants.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Member.g.dart';

Member memberFromJson(String str) => Member.fromJson(json.decode(str));

String memberToJson(Member data) => json.encode(data.toJson());

@JsonSerializable()
class Member {
  Member({
    required this.name,
    required this.position,
    required this.isEntered,
    required this.permission,
    required this.uid,
  });

  String name;
  List<String> position;
  bool isEntered;
  int permission;
  String uid;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);

  factory Member.fromDocument(DocumentSnapshot doc) {
    String name = "";
    List<String> position = List<String>.empty();
    bool isEntered = false;
    int permission = 0;

    try {
      name = doc.get(FirestoreConstants.name);
    } catch (e) {}
    try {
      List<dynamic> temp = doc.get(FirestoreConstants.position);
      position = temp.map((e) => e.toString()).toList();
    } catch (e) {
      print(e.toString());
    }
    try {
      isEntered = doc.get(FirestoreConstants.isEntered);
    } catch (e) {}
    try {
      permission = doc.get(FirestoreConstants.permission);
    } catch (e) {}

    return Member(
        name: name,
        position: position,
        isEntered: isEntered,
        permission: permission,
        uid: doc.id);
  }
}
