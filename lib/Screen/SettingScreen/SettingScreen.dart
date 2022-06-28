import 'dart:async';

import 'package:comuse/Constants/AppConstants.dart';
import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:comuse/Provider/Auth_provider.dart';
import 'package:comuse/Provider/Setting_provider.dart';
import 'package:comuse/Screen/SettingScreen/AdminScreen.dart';
import 'package:comuse/Screen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../Model/Member.dart';
import 'ChangeNameScreen.dart';
import 'SelectPositionScreen.dart';
import 'AdminPage/ManageScreen.dart';

const PositionData = ["guitar", "bass", "drum", "piano", "vocal", "other"];

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String uid = '';
  String name = '';
  List<String> position = <String>[];
  int permission = FirestoreConstants.noone;
  bool isEntered = false;
  String email = "";

  late SettingProvider settingProvider;
  late AuthProvider authProvider;

  StreamSubscription? userInfoStream;

  final List<String> entries = <String>[
    'Change Name',
    'Select Position',
    'Manage Members(admin)',
    'Permission'
  ];
  final List<Widget> screens = <Widget>[
    const ChangeNameScreen(),
    const ChangePositionScreen(),
    const ManageScreen(),
  ];

  @override
  void initState() {
    super.initState();
    settingProvider = context.read<SettingProvider>();
    authProvider = context.read<AuthProvider>();

    // check Login
    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      readLocal();
      userInfoStream ??= settingProvider.getUserInfoStream(uid).listen((ds) {
        Member userInfo = Member.fromDocument(ds);
        updateUserInfoLocal(userInfo).then((value) {
          setState(() {
            readLocal();
          });
        });
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> updateUserInfoLocal(Member userInfo) async {
    await settingProvider.setNamePref(userInfo.name);
    await settingProvider.setPermissionPref(userInfo.permission);
    await settingProvider.setPositionPref(userInfo.position);
  }

  void readLocal() {
    setState(() {
      uid = settingProvider.getUidPref() ?? "";
      name = settingProvider.getNamePref() ?? "";
      position = settingProvider.getPositionPref()?.toList() ?? <String>[];
      permission =
          settingProvider.getPermissionPref() ?? FirestoreConstants.noone;
      isEntered = settingProvider.getIsEnteredPref() ?? false;
      email = settingProvider.getEmailPref() ?? "";
    });
  }

  @override
  void dispose() {
    userInfoStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 70),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Stack(children: [
              Container(
                child: TextButton(
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              ),
              Center(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                    child: const Text('Settings',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ))),
              ),
            ]),
          )),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Account',
                    style: TextStyle(
                      fontSize: 15,
                    )),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      Text(email),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: const Text('Position', style: TextStyle(fontSize: 15)),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: position.isEmpty != true
                      // if position is not empty, view instrument
                      ? SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: position.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 50,
                                  height: 50,
                                  child: Image(
                                    width: 50,
                                    height: 50,
                                    image: AssetImage(AppConstants
                                        .instPath[position[index]]!),
                                  ));
                            },
                          ),
                        )
                      // if position is empty, view nothing selected
                      : const Text('nothing selected'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                makeEntryButton('Change Name', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeNameScreen()));
                }),
                makeEntryButton('Select Position', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePositionScreen()));
                }),
                makeEntryButton('Admin Only', () {
                  permission == FirestoreConstants.admin
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => AdminScreen())))
                      : Fluttertoast.showToast(msg: 'Admin Only');
                }),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.fromLTRB(20, 50, 20, 100),
                  child: OutlinedButton(
                      child: const Text('Log Out',
                          style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1.0, color: Colors.red),
                      ),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                  content: Text('Log Out of ' + name + "?",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('cancel')),
                                    TextButton(
                                        onPressed: () {
                                          authProvider
                                              .handleSignOut()
                                              .then((_) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()));
                                          });
                                        },
                                        child: const Text('Log out',
                                            style:
                                                TextStyle(color: Colors.red))),
                                  ]))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget makeEntryButton(String text, Function onPress) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                child: Row(children: [
                  Text(text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      )),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 20,
                  )
                ]),
                onPressed: () {
                  onPress();
                }),
            const Divider(
              color: Colors.grey,
              height: 1,
            )
          ],
        ));
  }
}
