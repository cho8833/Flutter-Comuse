import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Member.dart';

class MemberProvider {
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;
  List<Member> memberList = <Member>[];
  List<Member> adminList = <Member>[];
  List<Member> nooneList = <Member>[];

  void setMember(Member member) {
    int adminIndex =
        adminList.indexWhere((element) => element.uid == member.uid);
    int memberIndex =
        memberList.indexWhere((element) => element.uid == member.uid);
    if (member.permission == FirestoreConstants.admin) {
      if (adminIndex > -1) {
        adminList[adminIndex] = member;
      } else {
        adminList.add(member);
      }
      if (memberIndex > -1) {
        memberList.removeAt(memberIndex);
      }
    } else if (member.permission == FirestoreConstants.member) {
      if (memberIndex > -1) {
        memberList[memberIndex] = member;
      } else {
        memberList.add(member);
      }
      if (adminIndex > -1) {
        adminList.removeAt(adminIndex);
      }
    }
  }

  void deleteMember(Member member) {
    if (member.permission == FirestoreConstants.admin) {
      int index = adminList.indexWhere((element) => element.uid == member.uid);
      if (index > -1) {
        adminList.removeAt(index);
      }
    } else if (member.permission == FirestoreConstants.member) {
      int index = memberList.indexWhere((element) => element.uid == member.uid);
      if (index > -1) {
        memberList.removeAt(index);
      }
    }
  }

  MemberProvider({required this.firebaseFirestore, required this.prefs});
  Future<QuerySnapshot<Map<String, dynamic>>> getMembersExceptNoOne() {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMemberCollection)
        .where('permission', isGreaterThan: 101)
        .get();
  }

  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  Future<void> deleteDataFirestore(String uid) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMemberCollection)
        .doc(uid)
        .delete();
  }
}
