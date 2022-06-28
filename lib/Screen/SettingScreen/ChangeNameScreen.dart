import 'package:comuse/Provider/EnteredMemberProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../Constants/FirebaseConstants.dart';
import '../../Provider/Setting_provider.dart';

class ChangeNameScreen extends StatefulWidget {
  const ChangeNameScreen({Key? key}) : super(key: key);

  @override
  State<ChangeNameScreen> createState() => _ChangeNameScreenState();
}

class _ChangeNameScreenState extends State<ChangeNameScreen> {
  late SettingProvider settingProvider;
  late EnteredMemberProvider enteredProvider;
  late String name;
  late String uid;

  late TextEditingController nameController;

  @override
  void initState() {
    settingProvider = context.read<SettingProvider>();
    enteredProvider = context.read<EnteredMemberProvider>();

    uid = settingProvider.getUidPref() ?? "";
    name = settingProvider.getNamePref() ?? "";

    nameController = TextEditingController(text: name);
    super.initState();
  }

  void handleUpdateData(
      String _uid, String _name, Function onSuccess, Function(String) onFail) {
    settingProvider.updateDataFirestore(FirestoreConstants.pathMemberCollection,
        _uid, {'name': _name}).then((value) async {
      onSuccess();
    }).catchError((err) {
      onFail(err.toString());
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
                    child: const Text('Change Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ))),
              ),
            ]),
          )),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: const Text('Input Your Name',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
              controller: nameController,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                handleUpdateData(uid, nameController.text, () {
                  Fluttertoast.showToast(msg: 'Update Success');
                  Navigator.pop(context);
                }, (err) {
                  Fluttertoast.showToast(msg: err);
                  Navigator.pop(context);
                });
              },
              child: const Text('Change Name', style: TextStyle(fontSize: 15)),
            ),
          )
        ],
      ),
    );
  }
}
