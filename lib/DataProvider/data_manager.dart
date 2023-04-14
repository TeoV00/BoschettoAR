import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tree_ar/DataModel/share_data_model.dart';
import 'package:tree_ar/Database/database.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/DataProvider/firebase_provider.dart';
import '../DataModel/data_model.dart';
import '../Database/database_constant.dart';
import '../utils.dart';
import 'package:collection/collection.dart' as coll;
// import 'package:http/http.dart' as http;

const double weightPaperKg = 0.005;

class DataManager extends ChangeNotifier {
  final DatabaseProvider _dbProvider = DatabaseProvider.dbp;
  final FirebaseProvider _firebaseProvider = FirebaseProvider();
  int currentUserId = defaultUserId; //next feature could be multiuser in app

  ///Download and get from web or cloud db data used by the app
  Future<void> fetchOnlineData() async {
    //get project data json from existing web service
    List<Tree>? trees = await _firebaseProvider.getTrees();
    if (trees != null) {
      _dbProvider.insertBatchTrees(trees);
    }
    List<Project>? projs = await _fetchProjects();
    if (projs != null) {
      _dbProvider.insertBatchProjects(projs);
    }
  }

  /// Fetch projects online data and save in local db computing missing info
  Future<List<Project>?> _fetchProjects() async {
    Map<String, int>? treeIdByProjName =
        await _firebaseProvider.getRelationshipProjAndTree();

    List<Map<String, dynamic>>? projWeb = await _fetchProjectsFromWeb();
    List<Project> projs = [];

    if (projWeb != null && treeIdByProjName != null) {
      for (var elem in projWeb) {
        int? idOfTree = treeIdByProjName[elem['projectName']];

        if (idOfTree != null) {
          if (elem['co2risparmiata'] == 0) {
            elem['co2risparmiata'] = elem['carta'] * weightPaperKg;
          }
          projs.add(
            Project(
              projectId: idOfTree,
              treeId: idOfTree,
              projectName: elem['projectName'],
              category: elem['category'],
              descr: elem['description'],
              paper: double.parse(elem['carta'].toString()),
              treesCount: double.parse(elem['trees'].toString()),
              years: elem['years'],
              co2Saved: double.parse(elem['co2risparmiata'].toString()),
              projImage: categoryImage[elem['category']] ??
                  defaultItemImage[InfoType.project]!,
            ),
          );
        }
      }
    }

    return projs.isEmpty ? null : projs;
  }

  /// Get projects data from web (json)
  /// [return] list of map
  Future<List<Map<String, dynamic>>?> _fetchProjectsFromWeb() async {
    log("Fetch dati progetti");
    List<Map<String, dynamic>>? projFromWeb;
    //TODO: get project from an http request
    //final response = await http.get(Uri.parse(urlProjectInfo));
    String text = await rootBundle.loadString('assets/projects.json');

    // if (response.statusCode == 200) {
    projFromWeb = (jsonDecode(text) as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    // }

    return projFromWeb;
  }

  Future<Map<TreeSpecs, Pair<num, num>>> getBoundsOfTreeVal() {
//  co2,
//   paper,
//   height,
//   diameter,
//   maxTemp,
//   minTemp,
//   water;

    return _dbProvider.getBoundariesTreeValues();
  }

  /// Get user statistics and badges
  Future<Map<UserData, dynamic>> getUserData() async {
    log("getUser data");

    Statistics stats = await _calculateStats();

    Map<GoalBadge, bool> badges = {};
    Set<int> userBadges = await _dbProvider.getUserBadges(currentUserId);

    for (var domainBadge in appBadges) {
      badges.putIfAbsent(
          domainBadge, () => userBadges.contains(domainBadge.id));
    }

    return {
      UserData.stats: stats,
      UserData.badge: badges,
    };
  }

  num _getTotalOn(reductionAttribute, List<dynamic> listElems) {
    num total = 0;

    try {
      total = listElems
          .map(reductionAttribute)
          .reduce((localTotal, elemValue) => localTotal += elemValue);
    } catch (e) {
      total = 0;
    }
    return total;
  }

  /// Compute statistics values (co2 trees, savedCo2, total height, papers, progress perc)
  Future<Statistics> _calculateStats() async {
    List<Tree> trees = await _dbProvider.getUserTrees(currentUserId);
    List<Project> proj = await _dbProvider.getUserProjects(currentUserId);

    int totCo2Tree = _getTotalOn((e) => (e as Tree).co2, trees).toInt();
    int totalHeight = _getTotalOn((e) => (e as Tree).height, trees).toInt();

    int totSavedCo2Proj =
        _getTotalOn((e) => (e as Project).co2Saved, proj).toInt();

    var userProject = await _dbProvider.getUserProjects(currentUserId);
    int papers = userProject.isNotEmpty
        ? userProject.map((e) => e.paper).reduce((val, e) => val += e).toInt()
        : 0;

    var unlockedBadge = await _dbProvider.getUserBadges(currentUserId);

    double progressPerc = unlockedBadge.isNotEmpty
        ? double.parse(((unlockedBadge.length / appBadges.length) * 100)
            .toString()
            .substring(0, 5))
        : 0.0;

    return Statistics(
      papers,
      totCo2Tree,
      totalHeight,
      totSavedCo2Proj,
      progressPerc,
    );
  }

  ///update current logged-in user's info
  ///return true if any edit has been done, false if anything was not updated
  /// or there was any problem
  Future<bool> updateCurrentUserInfo(User user) async {
    var res = await _dbProvider.updateUserInfo(
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
    var user = await _dbProvider.getUserInfo(currentUserId);
    return user ?? defaultUser;
  }

  Future<Map<InfoType, List<dynamic>>> getUserTreesProject() async {
    //retrieve data saved in database - local memory
    List<Tree> trees = await _dbProvider.getUserTrees(currentUserId);
    List<Project> projc = await _dbProvider.getUserProjects(currentUserId);

    var userTreeAndProj = {
      InfoType.tree: trees,
      InfoType.project: projc,
    };

    return userTreeAndProj;
  }

  //SETTER methods
  void _addUserTree(int treeId) async {
    await _dbProvider.addUserTree(currentUserId, treeId);
  }

  void unlockUserBadge() async {
    Set<int> userBadges = await _dbProvider.getUserBadges(currentUserId);

    if (userBadges.isEmpty) {
      //add first badge (idBadge = 1)
      _dbProvider.addUserBadge(currentUserId, 1);
      log("Added fisrt badge");
    } else {
      log("more badges unlocked");
      int maxBadgeId = userBadges.max;
      //appBadges are defined in database_constant file, is better than get badges from db
      if (maxBadgeId + 1 < appBadges.length) {
        log("unlock badge num. ${maxBadgeId + 1}");
        _dbProvider.addUserBadge(currentUserId, maxBadgeId + 1);
      } else {
        log("All badge unlocked");
      }
    }
    notifyListeners();
  }

  Future<Map<InfoType, dynamic>?> isValidTreeCode(String qrData) async {
    log("isValidtreeCode Called");
    var treeId = int.parse(qrData);

    Tree? tree = await _dbProvider.getTree(treeId);
    Project? proj = await _dbProvider.getProject(treeId);
    List<Tree> userTrees = await _dbProvider.getUserTrees(currentUserId);
    bool isNewTree = userTrees.where((tree) => tree.treeId == treeId).isEmpty;
    log("Albero: ${tree == null ? 'Null' : 'presente'}");
    log("Progetto: ${proj == null ? 'Null' : 'presente'}");

    Map<TreeSpecs, Pair<num, num>> treeMaxValues = await getBoundsOfTreeVal();

    if (tree != null && proj != null) {
      if (isNewTree) {
        unlockUserBadge();
        _addUserTree(treeId);
      }
      return {
        InfoType.tree: tree,
        InfoType.project: proj,
        InfoType.other: treeMaxValues
      };
    } else {
      //no data available and code is not valid
      return null;
    }
  }

  /**
   * TOTEM and USER DATA
   */
  /// Upload user data to specific totem
  Future<bool> uploadUserData(String totemIdName) async {
    List<TotemInfo>? totems = await _firebaseProvider.getTotems();

    bool totemExist =
        totems != null ? totems.any((t) => t.totemId == totemIdName) : false;
    if (totemExist) {
      SharedData dataToUpload = await _getDataToUpload();
      log(dataToUpload.toString());
      return true;
    } else {
      log("Scanned qr correspond to any totem");
      return false;
    }
  }

  Future<SharedData> _getDataToUpload() async {
    Map<UserData, dynamic> usrData = await getUserData();
    Statistics stats = usrData[UserData.stats];
    int badgeCount = (usrData[UserData.badge] as Map<GoalBadge, bool>).length;
    int treesCount = (await _dbProvider.getUserTrees(currentUserId)).length;

    return SharedData(
        nickname: "h", //TODO: get nickname from sharedPreferences
        badgeCount: badgeCount,
        co2: stats.co2,
        level: stats.progressPerc.toInt(),
        paper: stats.papers,
        treesCount: treesCount);
  }
}
