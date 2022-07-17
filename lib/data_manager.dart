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

  DatabaseProvider dbProvider = DatabaseProvider.dbp;

  //TODO: metodo che copia gli alberi da server online a db locale

  // GETTER methods
  Future<Map<InfoType, List>> getUserTreesProject(int userId) async {
    //from id of tree get information from source
    final trees = await dbProvider.getUserTrees(userId);
    final projc = await dbProvider.getUserProjects(userId);
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

  static int getCurrentUserId() {
    //in user preferencies get current user id
    //the app for now not support multi user
    return DEFAULT_USER_ID;
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
}
