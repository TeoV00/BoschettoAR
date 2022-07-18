import 'package:flutter/material.dart';
import 'package:tree_ar/Database/database.dart';
import 'package:tree_ar/constant_vars.dart';
import 'Database/dataModel.dart';
import 'Database/database_constant.dart';

class DataManager extends ChangeNotifier {
  ///static function to get trees or Projects items scanned byt user to be showed
  ///in listview.
  //TODO: save in user preferences user id
  int currentUserId = DEFAULT_USER_ID;
  User? _currentCachedUser;

  DatabaseProvider dbProvider = DatabaseProvider.dbp;

  DataManager() {
    _refreshChachedUserInfo();
  }

  //TODO: metodo che copia gli alberi da server online a db locale

  User? getUser() {
    print(_currentCachedUser.toString());
    return _currentCachedUser;
  }

  void updateUserInfo(
    int userId,
    String? name,
    String? surname,
    String? dateBirth,
    String? course,
    String? registrationDate,
    String? userImageName,
  ) async {
    var usr = getUser();
    if (usr != null) {
      var execDone = await dbProvider.updateUserInfo(
        usr.userId,
        isNull(name) ? usr.name : name!,
        isNull(surname) ? usr.surname : surname!,
        isNull(dateBirth) ? usr.dateBirth : dateBirth!,
        isNull(course) ? usr.course : course!,
        isNull(registrationDate) ? usr.registrationDate : registrationDate!,
        isNull(userImageName) ? usr.userImageName : userImageName!,
      );
      if (execDone == true) {
        _refreshChachedUserInfo();
      }
    }
    print(_currentCachedUser.toString());
  }

  _refreshChachedUserInfo() async {
    var user = await dbProvider.getUserInfo(currentUserId);
    _currentCachedUser = user;
    notifyListeners();
  }

  Map<InfoType, List> getUserTreesProject() {
    //from id of tree get information from source
    List<Tree> trees = List.empty();
    List<Project> projc = List.empty();
    dbProvider.getUserTrees(currentUserId).then((result) => {trees = result});
    dbProvider
        .getUserProjects(currentUserId)
        .then((result) => {projc = result});

    return {
      InfoType.tree: trees,
      InfoType.project: projc,
    };
  }

  Tree? getTreeById(int id) {
    Tree? result;
    dbProvider.getTree(id).then((tree) => {result = tree});
    return result;
  }

  Project? getProjectById(int id) {
    Project? result;
    dbProvider.getProject(id).then((proj) => result = proj);
    return result;
  }

  Future<List<Badge>> getBadges() {
    return dbProvider.getUserBadges(currentUserId);
  }

  //ADDING methods
  void addUserTree(int treeId) {
    dbProvider.addUserTree(currentUserId, treeId);
    notifyListeners();
  }

  void unlockUserBadge(int idBadge) {
    dbProvider.addUserBadge(currentUserId, idBadge);
    notifyListeners();
  }

  bool isValidTreeCode(String qrData) {
    //TODO: get valid ids from online server or from cached trees donwloade form online db
    return true;
  }

  bool isNull(dynamic elem) {
    return elem == null;
  }
}
