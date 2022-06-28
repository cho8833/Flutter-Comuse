import 'package:animated_check/animated_check.dart';
import 'package:comuse/Constants/FirebaseConstants.dart';
import 'package:comuse/Provider/Setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../Constants/AppConstants.dart';

class ChangePositionScreen extends StatefulWidget {
  const ChangePositionScreen({Key? key}) : super(key: key);

  @override
  State<ChangePositionScreen> createState() => _ChangePositionScreenState();
}

class _ChangePositionScreenState extends State<ChangePositionScreen>
    with TickerProviderStateMixin {
  late List<String> position;
  late String uid;
  late SettingProvider provider;
  Map<String, String> screenPath = {
    "piano": "assets/images/screen/pianoScreen.png",
    "drum": "assets/images/screen/drumScreen.png",
    "guitar": "assets/images/screen/guitarScreen.png",
    "bass": "assets/images/screen/bassScreen.png",
    "vocal": "assets/images/screen/vocalScreen.png",
  };
  final Map<String, AnimationController> _animationControllers = Map();
  final Map<String, Animation<double>> _animations = Map();

  void readLocal() {
    setState(() {
      position = provider.getPositionPref() ?? <String>[];
      uid = provider.getUidPref() ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < AppConstants.instPath.length; i++) {
      AnimationController _animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 375));
      _animationControllers[AppConstants.instPath.keys.elementAt(i)] = _animationController;
      Animation<double> _animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOutCirc));
      _animations[AppConstants.instPath.keys.elementAt(i)] = _animation;
    }

    provider = context.read<SettingProvider>();
    readLocal();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      for (var i = 0; i < position.length; i++) {
        _animationControllers[position[i]]?.forward();
      }
    });
  }

  void handleUpdateData(String _position, bool isAdd, Function onSuccess,
      Function(String) onFail) {
    if (isAdd) {
      position.remove(_position);
    } else {
      position.add(_position);
    }
    provider.updateDataFirestore(FirestoreConstants.pathMemberCollection, uid,
        {'position': position}).then((value) async {
      onSuccess();
    }).catchError((err) {
      onFail(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 70),
            child: Container(
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
                      child: const Text('Select Position',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ))),
                ),
              ]),
            )),
        body: AnimationLimiter(
            child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(5, (int index) {
                  return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                            child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      screenPath.values.elementAt(index))),
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                )
                              ]),
                          child: TextButton(
                            child: Stack(children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(children: [
                                      Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 5),
                                          child: Image(
                                            image: AssetImage(AppConstants.instPath.values
                                                .elementAt(index)),
                                            width: 100,
                                            height: 100,
                                          )),
                                      AnimatedCheck(
                                        progress: _animations[
                                            AppConstants.instPath.keys.elementAt(index)]!,
                                        size: 100,
                                        color: Colors.amber,
                                      )
                                    ]),
                                    Text(AppConstants.instPath.keys.elementAt(index),
                                        style: const TextStyle(
                                            fontFamily: 'pacifico',
                                            color: Colors.white,
                                            fontSize: 18))
                                  ],
                                ),
                              ),
                            ]),
                            onPressed: () {
                              String inst = AppConstants.instPath.keys.elementAt(index);
                              bool isAdd = false;
                              if (_animationControllers[
                                              AppConstants.instPath.keys.elementAt(index)]
                                          ?.status ==
                                      AnimationStatus.completed ||
                                  _animationControllers[
                                              AppConstants.instPath.keys.elementAt(index)]
                                          ?.status ==
                                      AnimationStatus.forward) {
                                isAdd = true;
                              }
                              handleUpdateData(inst, isAdd, () {
                                Fluttertoast.showToast(msg: 'Update Success');
                                if (!isAdd) {
                                  _animationControllers[inst]?.forward();
                                } else {
                                  _animationControllers[inst]?.reset();
                                }
                              }, (err) {
                                Fluttertoast.showToast(msg: 'Update Fail');
                              });
                            },
                          ),
                        )),
                      ));
                }))));
  }
}
