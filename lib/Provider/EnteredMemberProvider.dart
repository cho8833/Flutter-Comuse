import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/FirebaseConstants.dart';
import '../Model/Member.dart';
import '../Model/MemberList.dart';

class EnteredMemberProvider {
  final FirebaseFirestore firebaseFirestore;

  EnteredMemberProvider({required this.firebaseFirestore});
  
  MemberList memberList = MemberList();

  Stream<QuerySnapshot> getEnteredMemberStream() {
    return firebaseFirestore
        .collection(FirestoreConstants.pathEnteredCollection)
        .snapshots();
  }

  Future<void> updateEnterFirestore(bool value, Member member) {
    if (value) {
      return firebaseFirestore
          .collection(FirestoreConstants.pathEnteredCollection)
          .doc(member.uid)
          .set(member.toJson());
    } else {
      return firebaseFirestore
          .collection(FirestoreConstants.pathEnteredCollection)
          .doc(member.uid)
          .delete();
    }
  }
  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }
}
