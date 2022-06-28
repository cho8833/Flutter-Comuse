import 'package:comuse/Model/Member.dart';

class MemberList {
  List<Member> entered = <Member>[];

  void out(Member member) {
    int enterIndex = entered.indexWhere((element) => element.uid == member.uid);
    if (enterIndex > -1) {
      entered.removeAt(enterIndex);
    }
  }

  void enter(Member member) {
    int enterIndex = entered.indexWhere((element) => element.uid == member.uid);
    if (enterIndex > -1) {
      entered[enterIndex] = member;
    } else {
      entered.insert(0, member);
    }
  }
}
