import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:comuse/Model/Member.dart';
import 'package:comuse/Model/MemberList.dart';
import 'package:comuse/Provider/Auth_provider.dart';
import 'package:comuse/Provider/Member_provider.dart';
import 'package:comuse/Provider/Setting_provider.dart';
import 'package:comuse/Screen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../Constants/Style.dart';

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
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Entered', style: Style.chapterTextStyle),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: memberList.entered.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SizedBox(
                    height: 25,
                    child: Container(
                        color: Colors.amber,
                        child: Row(
                          children: [
                            Expanded(
                                child: ListView.builder(
                              itemCount:
                                  memberList.entered[index].position.length,
                              itemBuilder: (context, pIndex) {
                                return Container(
                                    color: Colors.amberAccent,
                                    child: SizedBox(
                                      child: Text(memberList
                                          .entered[index].position[pIndex]),
                                    ));
                              },
                            )),
                            Expanded(
                              child: Text(memberList.entered[index].name),
                            )
                          ],
                        )));
              },
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text('NotEntered', style: Style.chapterTextStyle),
          ),
          Expanded(
              flex: 5,
              child: ListView.builder(
                itemCount: memberList.notEntered.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SizedBox(
                      height: 25,
                      child: Container(
                        color: Colors.amberAccent,
                        child: Row(
                          children: [
                            Expanded(
                                child: ListView.builder(
                                    itemCount: memberList
                                        .notEntered[index].position.length,
                                    itemBuilder: (context, pIndex) {
                                      return Container(
                                        color: Colors.amber,
                                        child: Text(memberList.notEntered[index]
                                            .position[pIndex]),
                                      );
                                    })),
                            Expanded(
                              child: Text(memberList.notEntered[index].name),
                            )
                          ],
                        ),
                      ));
                },
              ))
        ],
      )),
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
    );
  }
}
