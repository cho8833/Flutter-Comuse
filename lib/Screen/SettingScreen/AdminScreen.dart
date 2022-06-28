import 'package:comuse/Screen/SettingScreen/AdminPage/HistoryScreen.dart';
import 'package:comuse/Screen/SettingScreen/AdminPage/ManageScreen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
                      child: const Text('Admin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ))),
                ),
              ]),
            )),
        body: ListView(children: [
          makeEntryButton('Manage Members', ManageScreen()),
          makeEntryButton('History', HistoryScreen())
        ]));
  }

  Widget makeEntryButton(String text, Widget onPressPage) {
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => onPressPage));
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
            )
          ],
        ));
  }
}
