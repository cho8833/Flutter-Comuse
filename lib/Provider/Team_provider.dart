import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:comuse/Model/Team.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamProvider {
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  TeamProvider({required this.firebaseFirestore, required this.prefs});

  Stream<QuerySnapshot> getTeamStream() {
    return firebaseFirestore
        .collection(FirestoreConstants.pathTeamCollection)
        .snapshots();
  }

  Future<void> setTeam(Team team) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathTeamCollection)
        .doc(team.teamID)
        .set(team.toJson());
  }

  void removeTeam(Team team) {
    firebaseFirestore
        .collection(FirestoreConstants.pathTeamCollection)
        .doc(team.teamID)
        .delete();
  }
}
