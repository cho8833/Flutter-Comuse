import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:comuse/Model/Member.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'Team.g.dart';

@JsonSerializable(explicitToJson: true)
class Team {
  Team(
      {required this.leader,
      required this.session,
      required this.teamName,
      required this.songs,
      this.teamID}) {
    teamID ??= const Uuid().v1();
  }

  Member leader;
  Session session;
  String teamName;
  List<String> songs;
  String? teamID;

  Map<String, dynamic> toJson() => _$TeamToJson(this);
  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  factory Team.fromDocument(DocumentSnapshot ds) {
    Member _leader = Member(
        name: "",
        position: List<String>.empty(),
        isEntered: false,
        permission: FirestoreConstants.noone,
        uid: "");
    Session _session = Session.empty();
    String _name = "";
    String _id = "";
    List<String> _songs = List<String>.empty();

    try {
      _leader = Member.fromJson(ds.get(FirestoreConstants.leader));
    } catch (e) {}
    try {
      _session = Session.fromJson(ds.get(FirestoreConstants.session));
    } catch (e) {}
    try {
      _name = ds.get(FirestoreConstants.teamName);
    } catch (e) {}
    try {
      _id = ds.get(FirestoreConstants.teamID);
    } catch (e) {}
    try {
      _songs = ds.get(FirestoreConstants.songs);
    } catch (e) {}

    return Team(
        leader: _leader,
        session: _session,
        teamName: _name,
        teamID: _id,
        songs: _songs);
  }
}

@JsonSerializable(explicitToJson: true)
class Session {
  Session({
    required this.guitar,
    required this.piano,
    required this.vocal,
    required this.bass,
    required this.drum,
    required this.other,
  });

  List<Member> guitar;
  List<Member> piano;
  List<Member> vocal;
  List<Member> bass;
  List<Member> drum;
  Map<String, Member> other;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  factory Session.empty() {
    return Session(
        guitar: [], piano: [], vocal: [], bass: [], drum: [], other: {});
  }
}
