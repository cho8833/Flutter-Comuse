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
    required this.permission,
    required this.uid,
    required this.email,
  });

  final String name;
  List<String> position;
  int permission;
  String uid;
  String email;
  

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);

  factory Member.fromDocument(DocumentSnapshot doc) {
    String name = "";
    List<String> position = List<String>.empty();
    int permission = 0;
    String email = "";

    try {
      name = doc.get(FirestoreConstants.name);
    } catch (e) {}
    try {
      List<dynamic> temp = doc.get(FirestoreConstants.position);
      position = temp.map((e) => e.toString()).toList();
    } catch (e) {}
    try {
      permission = doc.get(FirestoreConstants.permission);
    } catch (e) {}
    try {
      email = doc.get(FirestoreConstants.email);
    } catch (e) {}

    return Member(
        name: name,
        position: position,
        permission: permission,
        uid: doc.id,
        email: email);
  }
}
