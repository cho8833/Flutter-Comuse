import '../Model/Member.dart';

class UserInfo {
  
  UserInfo._privateConstructor();
  static final UserInfo _instance = UserInfo._privateConstructor();

  String _name = "";
  String _uid = "";
  String _email = "";
  
  UserInfo._internal() {
    
  }
  factory UserInfo() {
    return _instance;
  }
}
