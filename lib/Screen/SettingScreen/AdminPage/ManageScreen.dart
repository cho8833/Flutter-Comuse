import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:comuse/Constants/Style.dart';
import 'package:comuse/Provider/Member_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Model/Member.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({Key? key}) : super(key: key);

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  late MemberProvider provider;
  StreamSubscription? memberStream;
  final Map<int, String> permissions = {
    101: 'noone',
    102: 'member',
    103: 'admin'
  };
  final List<Map<String, dynamic>> _items = [
    {
      'value': 101,
      'label': 'noone',
    },
    {
      'value': 102, 
      'label': 'member'
    },
    {
      'value': 103, 
      'label': 'admin'
    }
  ];

  @override
  void initState() {
    provider = context.read<MemberProvider>();
    
  }

  @override
  void dispose() {
    memberStream?.cancel();
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
                      child: const Text('Manage Members',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ))),
                ),
              ]),
            )),
        body: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: const Text("Admin", style: Style.listChapterText)),
            Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1.0,
                            spreadRadius: 1.0)
                      ]),
                  child: ListView.builder(
                    itemCount: provider.adminList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Row(children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Column(
                              children: [
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 10),
                                    child: Text(provider.adminList[index].name,
                                        style: Style.listNameText)),
                                Text(provider.adminList[index].email),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                              child: TextButton(
                            child: Text(
                              permissions[
                                  provider.adminList[index].permission]!,
                            ),
                            onPressed: () {
                              showPermissionSelectDialog(
                                  provider.adminList[index].uid);
                            },
                          )),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              iconSize: 20,
                              onPressed: () {
                                deleteUserDialog(provider.adminList[index].uid);
                              },
                              icon: const Icon(Icons.close)),
                        )
                      ]);
                    },
                  ),
                )),
            Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: const Text("Member", style: Style.listChapterText)),
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1.0,
                          spreadRadius: 1.0)
                    ]),
                child: ListView.builder(
                  itemCount: provider.memberList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Column(
                            children: [
                              Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 10),
                                  child: Text(provider.memberList[index].name,
                                      style: Style.listNameText)),
                              Text(provider.memberList[index].email),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                            child: TextButton(
                          child: Text(
                            permissions[provider.memberList[index].permission]!,
                          ),
                          onPressed: () {
                            showPermissionSelectDialog(
                                provider.memberList[index].uid);
                          },
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                            iconSize: 20,
                            onPressed: () {
                              deleteUserDialog(provider.memberList[index].uid);
                            },
                            icon: const Icon(Icons.close)),
                      )
                    ]);
                  },
                ),
              ),
            )
          ],
        ));
  }

  void showPermissionSelectDialog(String uid) {
    updatePermission(int permission, BuildContext context) {
      provider.updateDataFirestore(FirestoreConstants.pathMemberCollection, uid,
          {'permission': permission});
      Navigator.pop(context);
    }

    TextStyle itemTextStyle = const TextStyle(
      color: Colors.black,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Column(children: const [
                Text(
                  'Select Permission',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    child: Text(
                      'No One',
                      style: itemTextStyle,
                    ),
                    onPressed: () {
                      updatePermission(101, context);
                    },
                  ),
                  TextButton(
                      child: Text(
                        'Member',
                        style: itemTextStyle,
                      ),
                      onPressed: () {
                        updatePermission(102, context);
                      }),
                  TextButton(
                      child: Text('Admin', style: itemTextStyle),
                      onPressed: () {
                        updatePermission(103, context);
                      })
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ]);
        });
  }

  void deleteUserDialog(String uid) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete User'),
            content: const Text('sure delete data?'),
            actions: <Widget>[
              TextButton(
                child: const Text('cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Delete',style: TextStyle(color: Colors.red),),
                onPressed: () {
                  provider.deleteDataFirestore(uid).then((value) {
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
  }
}
