import 'package:comuse/Screen/SettingScreen/AdminPage/HistoryDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
                    child: const Text('History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ))),
              ),
            ]),
          )),
      body: SfDateRangePicker(
        onSelectionChanged: ((args) {
          DateTime selected = args.value;
          Navigator.push(
                context, MaterialPageRoute(builder: (context) => HistoryDetailScreen(date: selected,)));
        }),
        view: DateRangePickerView.year),
    );
  }
}
