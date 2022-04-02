import 'package:comuse/Model/Team.dart';

class TeamList {
  List<Team> teamList = <Team>[];

  void add(Team team) {
    int index = teamList.indexWhere((element) => element.teamID == team.teamID);
    if (index > -1) {
      teamList[index] = team;
    } else {
      teamList.insert(0, team);
    }
  }

  void remove(Team team) {
    int index = teamList.indexWhere((element) => element.teamID == team.teamID);
    if (index > -1) {
      teamList.removeAt(index);
    }
  }
}
