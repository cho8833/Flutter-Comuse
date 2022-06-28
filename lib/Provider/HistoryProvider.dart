import 'package:comuse/Model/History.dart';
import 'package:firebase_database/firebase_database.dart';

class HistoryProvider {
  final DatabaseReference db;

  HistoryProvider({required this.db});
  
  Future<DataSnapshot> getHistory(year, month, day) {
    return db.child('Entered_history/$year/$month/$day').get();
  }
}
