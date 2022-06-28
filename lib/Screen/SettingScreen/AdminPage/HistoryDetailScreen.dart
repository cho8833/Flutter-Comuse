import 'dart:convert';

import 'package:comuse/Constants/Style.dart';
import 'package:comuse/Provider/HistoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Model/History.dart';

class HistoryDetailScreen extends StatefulWidget {
  final DateTime date;
  const HistoryDetailScreen({required this.date});

  @override
  State<HistoryDetailScreen> createState() =>
      _HistoryDetailScreenState(date: date);
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  _HistoryDetailScreenState({required this.date});
  final DateTime date;
  String title = "";
  List<History> histories = <History>[];
  late HistoryProvider provider;
  @override
  void initState() {
    super.initState();
    provider = context.read<HistoryProvider>();
    provider.getHistory(date.year, date.month, date.day).then((value) {
      if (value.exists) {
        List<History> list = <History>[];
        for (var element in value.children) {
          History data = History.fromData(element);
          list.add(data);
        }
        list.sort(((a, b) => -a.epoch.compareTo(-b.epoch)));
        setState(() {
          histories = list;
        });
      }
    });
    setState(() {
      title = DateFormat('MMM d, yyyy').format(date);
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
                      child: Text(title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ))),
                ),
              ]),
            )),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.all(10),
            decoration: Style.containerDeco,
            child: histories.isNotEmpty
                ? ListView.separated(
                    itemCount: histories.length,
                    itemBuilder: ((context, index) {
                      History history = histories[index];
                      return Container(
                          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Text(
                                      history.name,
                                      style: Style.listNameText,
                                    ),
                                    Text(history.email)
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: history.isEntered
                                      ? const Text('Enter')
                                      : const Text('Out'),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(DateFormat.jm()
                                          .format(history.date))))
                            ],
                          ));
                    }),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        thickness: 1,
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Center(child: Text('No History'))],
                  )));
  }
}
