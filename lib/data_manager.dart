import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tree_ar/Database/database.dart';
import 'package:tree_ar/constant_vars.dart';
import 'Database/dataModel.dart';
import 'Database/database_constant.dart';
import 'utils.dart';
import 'package:collection/collection.dart' as coll;

class DataManager extends ChangeNotifier {
  DatabaseProvider dbProvider = DatabaseProvider.dbp;
  int currentUserId = DEFAULT_USER_ID; //next feature could be multiuser in app

  DataManager() {
    pullTreeDataInDb();
  }

  void pullTreeDataInDb() {}
  //TODO: metodo che copia gli alberi da server online a db locale
  //TODO: save in user preferences user id

  ///get user info then when received, cache data to var then notify listeners
  Future<Map<UserData, dynamic>> getUserData() async {
    log("getUser data");

    Statistics stats = await _calculateStats();

    Map<Badge, bool> badges = {};
    Set<int> userBadges = await dbProvider.getUserBadges(currentUserId);

    for (var domainBadge in appBadges) {
      badges.putIfAbsent(
          domainBadge, () => userBadges.contains(domainBadge.id));
    }

    return {
      UserData.stats: stats,
      UserData.badge: badges,
    };
  }

  Future<Statistics> _calculateStats() async {
    int totCo2 = 0;
    try {
      List<Tree> trees = await dbProvider.getUserTrees(currentUserId);
      totCo2 = trees
          .map((e) => e.co2)
          .reduce((co2Total, treeCo2) => co2Total += treeCo2);
    } catch (e) {
      totCo2 = 0;
    }

    //TODO: il numero di fogli di carta li prendo dalla stessa fonte della verione
    //web cosi come i kg di co2 per ciascun progetto
    //TODO: la carta prendo in considerazione quella del progetto e non quella che
    //l'albero sarebbe in grado di catturare
    var papers = 202; //prendo

    var pogress = 0.8; //get that info from gameController
    return Statistics(papers, totCo2, pogress);
  }

  ///update current logged-in user's info
  ///return true if any edit has been done, false if anything was not updated
  /// or there was any problem
  Future<bool> updateCurrentUserInfo(User user) async {
    var res = await dbProvider.updateUserInfo(
      currentUserId,
      user.name,
      user.surname,
      user.dateBirth,
      user.course,
      user.registrationDate,
      user.userImageName,
    );
    return res;
  }

  ///Update snapshot of userInfo from db
  ///return true if data are on db and snapshot is updated
  Future<User> getUserInfo() async {
    var user = await dbProvider.getUserInfo(currentUserId);
    return user ?? defaultUser;
  }

  Future<Map<InfoType, List<dynamic>>> getUserTreesProject() async {
    //retrieve data saved in database - local memory
    List<Tree> trees = await dbProvider.getUserTrees(currentUserId);
    List<Project> projc = await dbProvider.getUserProjects(currentUserId);

    var userTreeAndProj = {
      InfoType.tree: trees,
      InfoType.project: projc,
    };

    return userTreeAndProj;
  }

  //SETTER methods
  void addUserTree(int treeId) async {
    await dbProvider.addUserTree(currentUserId, treeId);
  }

  void unlockUserBadge() async {
    var userBadges = await dbProvider.getUserBadges(currentUserId);

    if (userBadges.isEmpty) {
      //add first badge (idBadge = 0)
      dbProvider.addUserBadge(currentUserId, 0);
      log("Added fisrt badge");
    } else {
      log("more badges unlocked");
      int maxBadgeId = userBadges.max;
      //appBadges are defined in database_constant file, is better than get badges from db
      if (maxBadgeId + 1 < appBadges.length) {
        log("unlock badge num. ${maxBadgeId + 1}");
        dbProvider.addUserBadge(currentUserId, maxBadgeId + 1);
      } else {
        log("All badge unlocked");
      }
    }
  }

  Future<Map<InfoType, dynamic>?> isValidTreeCode(String qrData) async {
    log("isValidtreeCode Called");
    var treeId = int.parse(qrData);

    Tree? tree = await dbProvider.getTree(treeId);
    Project? proj = await dbProvider.getProject(treeId);
    List<Tree> userTrees = await dbProvider.getUserTrees(currentUserId);
    bool isNewTree = userTrees.where((tree) => tree.treeId == treeId).isEmpty;

    if (tree != null && proj != null && isNewTree) {
      unlockUserBadge();
      addUserTree(treeId);
      return {InfoType.tree: tree, InfoType.project: proj};
    } else {
      //no data available and code is not valid
      return null;
    }
  }
}
