import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../Constants/Style.dart';
import '../../Model/Member.dart';
import '../../Provider/Member_provider.dart';
import '../../Constants/AppConstants.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({Key? key}) : super(key: key);

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  late MemberProvider provider;
  List<Member> memberList = <Member>[];
  List<Member> adminList = <Member>[];

  @override
  void initState() {
    super.initState();
    provider = context.read<MemberProvider>();
    List<Member> memberTemp = <Member>[];
    List<Member> adminTemp = <Member>[];
    provider.getMembersExceptNoOne().then((QuerySnapshot qs) {
      qs.docs.forEach((element) {
        Member member = Member.fromDocument(element);
        switch (member.permission) {
          case 102:
            memberTemp.add(member);
            break;
          case 103:
            adminTemp.add(member);
            break;
        }
      });
      setState(() {
        memberList = memberTemp;
        adminList = adminTemp;
      });
    });
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
                      child: const Text('Members',
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
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: const Text("Admin",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ))),
            Expanded(
                flex: 1,
                child: AnimationLimiter(
                    child: ListView.builder(
                  itemCount: adminList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                        position: adminList.length,
                        duration: const Duration(milliseconds: 375),
                        child: FadeInAnimation(
                            child: ScaleAnimation(
                                child: Container(
                                    margin: const EdgeInsets.all(5),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 3.0,
                                              spreadRadius: 1.0,
                                              color: Colors.grey)
                                        ]),
                                    height: 50,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: ListView.builder(
                                              itemCount: adminList[index]
                                                  .position
                                                  .length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, pIndex) {
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  height: 50,
                                                  child: Image(
                                                    image: AssetImage(
                                                        AppConstants.instPath[
                                                            adminList[index]
                                                                    .position[
                                                                pIndex]]!),
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Text(adminList[index].name,
                                                  style: Style.listNameText))
                                        ])))));
                  },
                ))),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: const Text("Member",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ))),
            Expanded(
              flex: 5,
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: memberList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: memberList.length,
                      duration: const Duration(milliseconds: 375),
                      child: FadeInAnimation(
                        child: ScaleAnimation(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3.0,
                                      spreadRadius: 1.0,
                                      color: Colors.grey)
                                ]),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: ListView.builder(
                                    itemCount:
                                        memberList[index].position.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, pIndex) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        height: 50,
                                        child: Image(
                                          image: AssetImage(
                                              AppConstants.instPath[provider
                                                  .memberList[index]
                                                  .position[pIndex]]!),
                                          width: 50,
                                          height: 50,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Text(memberList[index].name,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        )))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
