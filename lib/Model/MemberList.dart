import 'package:comuse/Model/Member.dart';

class MemberList {
  List<Member> entered = <Member>[];
  List<Member> notEntered = <Member>[];

  void out(Member member) {
    int enterIndex = entered.indexWhere((element) => element.uid == member.uid);
    int notEnterIndex =
        notEntered.indexWhere((element) => element.uid == member.uid);
    if (enterIndex > -1) {
      entered.removeAt(enterIndex);
    }
    if (notEnterIndex > -1) {
      notEntered[notEnterIndex] = member;
    } else {
      notEntered.insert(0, member);
    }
  }

  void enter(Member member) {
    int enterIndex = entered.indexWhere((element) => element.uid == member.uid);
    int notEnterIndex =
        notEntered.indexWhere((element) => element.uid == member.uid);
    if (notEnterIndex > -1) {
      notEntered.removeAt(notEnterIndex);
    }
    if (enterIndex > -1) {
      entered[enterIndex] = member;
    } else {
      entered.insert(0, member);
    }
  }
}
