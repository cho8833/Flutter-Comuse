import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:comuse/Model/Member.dart';
import 'package:comuse/Model/MemberList.dart';
import 'package:comuse/Provider/Auth_provider.dart';
import 'package:comuse/Provider/EnteredMemberProvider.dart';
import 'package:comuse/Provider/Member_provider.dart';
import 'package:comuse/Provider/Setting_provider.dart';
import 'package:comuse/Screen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../Constants/AppConstants.dart';
import '../SettingScreen/SettingScreen.dart';
import '../../Constants/Style.dart';
import 'MemberListScreen.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({Key? key}) : super(key: key);

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  late SettingProvider settingProvider;
  late EnteredMemberProvider enteredProvider;
  late AuthProvider authProvider;
  late String currentUserId;

  StreamSubscription? enteredStream;
  StreamSubscription? userInfoStream;

  bool isLoading = false;

  bool isEntered = false;
  String uid = '';
  String name = '';
  Set<String> position = Set<String>.from(List<String>.empty());
  int permission = FirestoreConstants.noone;
  String email = '';

  void readUserInfoFromLocal() {
    setState(() {
      uid = settingProvider.getUidPref() ?? "";
      name = settingProvider.getNamePref() ?? "";
      position = settingProvider.getPositionPref()?.toSet() ??
          Set<String>.from(List<String>.empty());
      permission =
          settingProvider.getPermissionPref() ?? FirestoreConstants.noone;
      isEntered = settingProvider.getIsEnteredPref() ?? false;
      email = settingProvider.getEmailPref() ?? "";
    });
  }

  Future<void> updateUserInfoLocal(Member userInfo) async {
    await settingProvider.setNamePref(userInfo.name);
    await settingProvider.setPositionPref(userInfo.position);
    await settingProvider.setPermissionPref(userInfo.permission);
  }

  void handleEnterState(bool value) {
    setState(() {
      isLoading = true;
    });
    enteredProvider
        .updateEnterFirestore(
            value,
            Member(
                name: name,
                uid: uid,
                position: position.toList(),
                permission: permission,
                email: email
            )
        )
        .then((_) async {
      await settingProvider.setIsEnteredPref(value);
      setState(() {
        isEntered = value;
        isLoading = false;
      });
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  void dispose() {
    enteredStream?.cancel();
    userInfoStream?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    enteredProvider = context.read<EnteredMemberProvider>();
    settingProvider = context.read<SettingProvider>();
    authProvider = context.read<AuthProvider>();

    // check Login
    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getUserFirebaseId()!;
      // if login, get UserInfo Stream
      userInfoStream ??=
          settingProvider.getUserInfoStream(currentUserId).listen((event) {
        Member userInfo = Member.fromDocument(event);
        updateUserInfoLocal(userInfo).then((value) {
          readUserInfoFromLocal();
        });
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
    // get Entered Member Stream
    enteredStream ??= enteredProvider.getEnteredMemberStream().listen((event) {
      MemberList list = enteredProvider.memberList;
      event.docChanges.forEach((DocumentChange dc) {
        if (dc.doc.id == 'empty') {
          return;
        }
        Member member = Member.fromDocument(dc.doc);
        switch (dc.type) {
          case DocumentChangeType.added:
          case DocumentChangeType.modified:
            list.enter(member);
            break;
          case DocumentChangeType.removed:
            list.out(member);
            break;
        }
      });
      setState(() {
        enteredProvider.memberList = list;
      });
    });

    readUserInfoFromLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 70),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                      child: const Text('Comuse',
                          style:
                              TextStyle(fontFamily: 'Pacifico', fontSize: 30))),
                  Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: TextButton(
                            child: const Image(
                              image: AssetImage('assets/images/group.png'),
                              width: 30,
                              height: 30,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MemberListScreen()));
                            },
                          )),
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: TextButton(
                              child: const Image(
                                  image:
                                      AssetImage('assets/images/settings.png'),
                                  width: 25,
                                  height: 25),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingScreen()));
                              })),
                    ],
                  )
                ]),
          )),
      body: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: const Text('Entered',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              )),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
            ),
            height: MediaQuery.of(context).size.height / 1.3,
            child: enteredProvider.memberList.entered.isEmpty
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [Text('No one here...')]),
                  )
                : AnimationLimiter(
                    child: ListView.builder(
                      itemCount: enteredProvider.memberList.entered.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: enteredProvider.memberList.entered.length,
                          duration: const Duration(milliseconds: 375),
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  decoration: const BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 3.0,
                                          spreadRadius: 1.0,
                                        )
                                      ],
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 5,
                                          child: enteredProvider
                                                  .memberList
                                                  .entered[index]
                                                  .position
                                                  .isEmpty
                                              ? Container()
                                              : Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            enteredProvider
                                                                .memberList
                                                                .entered[index]
                                                                .position
                                                                .length,
                                                        shrinkWrap: true,
                                                        itemBuilder: (context,
                                                            positionIndex) {
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5),
                                                            child: Image(
                                                              image: AssetImage(AppConstants.instPath[
                                                                  enteredProvider
                                                                      .memberList
                                                                      .entered[
                                                                          index]
                                                                      .position[positionIndex]]!),
                                                              width: MediaQuery.of(context).size.width / 10,
                                                              height: 40,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                )),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 5, 0),
                                            child: Text(
                                                enteredProvider.memberList
                                                    .entered[index].name,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ))
                                    ],
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          )
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
