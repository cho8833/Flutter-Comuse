import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:comuse/Model/Member.dart';
import 'package:comuse/Provider/Setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

const PositionData = ["guitar", "bass", "drum", "piano", "vocal", "other"];

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController? controllerName;

  String uid = '';
  String name = '';
  Set<String> position = Set<String>.from(List<String>.empty());
  int permission = FirestoreConstants.noone;
  bool isEntered = false;

  bool isLoading = false;
  late SettingProvider provider;

  final FocusNode focusNodeName = FocusNode();

  @override
  void initState() {
    super.initState();
    provider = context.read<SettingProvider>();
    readLocal();
  }

  void readLocal() {
    setState(() {
      uid = provider.getUidPref() ?? "";
      name = provider.getNamePref() ?? "";
      position = provider.getPositionPref()?.toSet() ??
          Set<String>.from(List<String>.empty());
      permission = provider.getPermissionPref() ?? FirestoreConstants.noone;
      isEntered = provider.getIsEnteredPref() ?? false;
    });

    controllerName = TextEditingController(text: name);
  }

  void handleUpdateData() {
    setState(() {
      isLoading = true;
    });
    Member userInfo = Member(
      uid: uid,
      name: name,
      position: position.toList(),
      isEntered: isEntered,
      permission: permission
    );
    provider
        .updateDataFirestore(
            FirestoreConstants.pathMemberCollection, uid, userInfo.toJson())
        .then((_) async {
      await provider.setNamePref(name);
      await provider.setPositionPref(position.toList());

      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Member Name
        Container(
          child: const Text('Name'),
          margin: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
        ),
        Container(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Input Your Name',
              contentPadding: EdgeInsets.all(5),
            ),
            controller: controllerName,
            onChanged: (value) {
              name = value;
            },
            focusNode: focusNodeName,
          ),
          margin: const EdgeInsets.only(left: 30, right: 30),
        ),

        // Position
        Container(
          child: const Text('Position'),
          margin: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
        ),
        SizedBox(
          child: Row(
            children: [
              position.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: position.length,
                      itemBuilder: (context, index) {
                        List<String> _position = position.toList();
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(child: Text(_position[index])),
                        );
                      },
                    ))
                  : const Text('nothing selected..'),
              TextButton(
                  onPressed: () {
                    // select position
                    _showPositionSelect(context);
                  },
                  child: const Text('select'))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ],
    );
  }

  void _showPositionSelect(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return MultiSelectDialog(
            initialValue: position.toList(),
            items: PositionData.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            onConfirm: (values) {
              if (values.isNotEmpty) {
                position = values.map((e) => e.toString()).toSet();
                handleUpdateData();
              }
            },
          );
        });
  }
}
