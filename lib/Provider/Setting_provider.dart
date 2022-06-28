import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Member.dart';

class SettingProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;

  SettingProvider({
    required this.prefs,
    required this.firebaseFirestore,
  });
  String? getNamePref() {
    return prefs.getString(FirestoreConstants.name);
  }

  String? getUidPref() {
    return prefs.getString(FirestoreConstants.uid);
  }

  List<String>? getPositionPref() {
    return prefs.getStringList(FirestoreConstants.position);
  }

  String? getEmailPref() {
    return prefs.getString(FirestoreConstants.email);
  }

  int? getPermissionPref() {
    return prefs.getInt(FirestoreConstants.permission);
  }

  bool? getIsEnteredPref() {
    return prefs.getBool(FirestoreConstants.isEntered);
  }

  Future<bool> setNamePref(String value) async {
    return await prefs.setString(FirestoreConstants.name, value);
  }

  Future<bool> setEmailPref(String value) async {
    return await prefs.setString(FirestoreConstants.email, value);
  }

  Future<bool> setPositionPref(List<String> value) async {
    return await prefs.setStringList(FirestoreConstants.position, value);
  }

  Future<bool> setUidPref(String value) async {
    return await prefs.setString(FirestoreConstants.uid, value);
  }

  Future<bool> setPermissionPref(int value) async {
    return await prefs.setInt(FirestoreConstants.permission, value);
  }

  Future<bool> setIsEnteredPref(bool value) async {
    return await prefs.setBool(FirestoreConstants.isEntered, value);
  }

  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  Stream<DocumentSnapshot> getUserInfoStream(String uid) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMemberCollection)
        .doc(uid)
        .snapshots();
  }
}
