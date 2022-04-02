import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:comuse/Model/Team.dart';
import 'package:comuse/Model/TeamList.dart';
import 'package:comuse/Provider/Team_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../Model/Member.dart';
import '../Provider/Setting_provider.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  late TeamProvider teamProvider;
  late SettingProvider settingProvider;

  TeamList teamList = TeamList();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    teamProvider = context.read<TeamProvider>();
    settingProvider = context.read<SettingProvider>();

    readUserInfoFromLocal();

    // get Team Stream
    teamProvider.getTeamStream().listen((event) {
      TeamList list = teamList;
      event.docChanges.forEach((ds) {
        switch (ds.type) {
          case DocumentChangeType.added:
          case DocumentChangeType.modified:
            list.add(Team.fromDocument(ds.doc));
            break;
          case DocumentChangeType.removed:
            list.remove(Team.fromDocument(ds.doc));
            break;
        }
      });
      setState(() {
        teamList = list;
      });
    });
  }

  bool isEntered = false;
  String uid = '';
  String name = '';
  Set<String> position = Set<String>.from(List<String>.empty());
  int permission = FirestoreConstants.noone;
  List<TextEditingController> songControllers = <TextEditingController>[];
  
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: teamList.teamList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.grey,
              ),
              height: 100,
              child: Row(children: [
                Text(teamList.teamList[index].teamName),
                Text(teamList.teamList[index].leader.name),
              ]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          buildTeamDialog(null);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void buildTeamDialog(Team? team) {
    TextEditingController nameController = TextEditingController();
    
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => Scaffold(
              body: SafeArea(
                child: Container(
                    child: Column(
                  children: [
                    const Text(
                      'Team Name',
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: TextField(
                          controller: nameController,
                        )),
                    Row(
                      children: [
                        const Text(
                          'Songs',
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                songControllers.add(TextEditingController());
                              });
                            },
                            icon: const Icon(Icons.add))
                      ],
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: songControllers.length,
                          itemBuilder: (context, index) {
                            return TextField(
                              controller: songControllers[index]
                            );
                          },
                        ))
                  ],
                )),
              ),
            ));
  }
}
