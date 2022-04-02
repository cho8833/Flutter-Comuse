import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberProvider {
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  MemberProvider({required this.firebaseFirestore, required this.prefs});

  Stream<QuerySnapshot> getMemberStream() {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMemberCollection)
        .snapshots();
  }
}
