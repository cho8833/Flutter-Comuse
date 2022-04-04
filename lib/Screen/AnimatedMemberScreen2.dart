import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comuse/Constants/AppConstants.dart';
import 'package:comuse/Provider/Member_provider.dart';
import 'package:comuse/Provider/Setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../Constants/FirebaseConstants.dart';
import '../Model/Member.dart';
import '../Model/MemberList.dart';
import '../Provider/Auth_provider.dart';
import 'loginScreen.dart';

var instrumentPath = {
  "bass": "assets/images/bass.png",
  "piano": "assets/images/drum.png",
  "guitar": "assets/images/guitar.png",
  "drum": "assets/images/drum.png",
  "vocal": "assets/images/vocal.png"
};

class MemberScreen extends StatefulWidget {
  const MemberScreen({Key? key}) : super(key: key);

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  late MemberProvider memberProvider;
  late SettingProvider settingProvider;
  late AuthProvider authProvider;
  late String currentUserId;

  StreamSubscription? memberStream;

  bool isLoading = false;

  MemberList memberList = MemberList();
  Map<String, Widget> spriteList = {};

  bool isEntered = false;
  String uid = '';
  String name = '';
  Set<String> position = Set<String>.from(List<String>.empty());
  int permission = FirestoreConstants.noone;

  void readUserInfoFromLocal() {
    setState(() {
      uid = settingProvider.getUidPref() ?? "";
      name = settingProvider.getNamePref() ?? "";
      position = settingProvider.getPositionPref()?.toSet() ??
          Set<String>.from(List<String>.empty());
      permission =
          settingProvider.getPermissionPref() ?? FirestoreConstants.noone;
      isEntered = settingProvider.getIsEnteredPref() ?? false;
    });
  }

  void handleEnterState(bool value) {
    setState(() {
      isLoading = true;
    });
    settingProvider.updateEnterFirestore(value, uid).then((_) async {
      await settingProvider.setIsEnteredPref(value);
      isEntered = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    memberStream?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    memberProvider = context.read<MemberProvider>();
    settingProvider = context.read<SettingProvider>();
    authProvider = context.read<AuthProvider>();

    // check Login
    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getUserFirebaseId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }

    // get Member Stream
    memberStream = memberProvider.getMemberStream().listen((event) {
      MemberList list = memberList;
      event.docs.forEach((DocumentSnapshot ds) {
        Member member = Member.fromDocument(ds);
        if (member.isEntered) {
          list.enter(member);
        } else {
          list.out(member);
        }
      });
      
      setState(() {
        memberList = list;
      });
      
    });
    readUserInfoFromLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/background.png'))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              for (Member member in memberList.entered) Sprite(member: member)
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Text(isEntered ? 'Out' : 'Enter!'),
            onPressed: () {
              if (isEntered) {
                handleEnterState(false);
              } else {
                handleEnterState(true);
              }
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
    );
  }

  void addSprite(Member member) {
    spriteList[member.uid] = makeSprite(true, member.name, member.position[0]);
  }

  Widget makeSprite(bool gender, String name, String position) {
    String characterPath = gender
        ? 'assets/images/man_character.png'
        : 'assets/images/woman_character.png';
    String? instPath = instrumentPath[position];
    return SizedBox(
        child: Column(
      children: [
        Text(name),
        Stack(
          children: [
            Image(
              image: AssetImage(characterPath),
              width: 200,
              height: 200,
            ),
            Positioned(
                top: 100,
                child: Image(
                  image: AssetImage(instPath!),
                  width: 80,
                  height: 80,
                )
            )
          ],
        )
      ],
    ));
  }
}

class Sprite extends SizedBox {
  Sprite({required this.member});

  Member member;

  @override
  Widget? get child {
    String characterPath = true
        ? AppConstants.characterManImage
        : AppConstants.characterWomanImage;
    String? instPath = instrumentPath[member.position[0]];
    return Column(
      children: [
        Text(member.name),
        Stack(
          children: [
            Image(
              image: AssetImage(characterPath),
              width: 200,
              height: 200,
            ),
            Positioned(
                top: 100,
                child: Image(
                  image: AssetImage(instPath!),
                  width: 80,
                  height: 80,
                ))
          ],
        )
      ],
    );
  }
}
