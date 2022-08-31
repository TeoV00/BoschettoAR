import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tree_ar/Database/database.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/DataProvider/firebase_provider.dart';
import '../Database/data_model.dart';
import '../Database/database_constant.dart';
import '../Utils/unit_converter.dart';
import '../utils.dart';
import 'package:collection/collection.dart' as coll;
// import 'package:http/http.dart' as http;

const double weightPaperKg = 0.005;

class DataManager extends ChangeNotifier {
  DatabaseProvider dbProvider = DatabaseProvider.dbp;
  FirebaseProvider firebaseProvider = FirebaseProvider();

  int currentUserId = defaultUserId; //next feature could be multiuser in app

  ///Download and get from web or cloud db data used by the app
  Future<void> fetchOnlineData() async {
    //get project data json from existing web service
    List<Tree>? trees = await firebaseProvider.getTrees();
    if (trees != null) {
      dbProvider.insertBatchTrees(trees);
    }
    List<Project>? projs = await _fetchProjects();
    if (projs != null) {
      dbProvider.insertBatchProjects(projs);
    }
  }

  Future<List<Project>?> _fetchProjects() async {
    Map<String, int>? treeIdByProjName =
        await firebaseProvider.getRelationshipProjAndTree();

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
                co2Saved: double.parse(elem['co2risparmiata'].toString())),
          );
        }
      }
    }

    return projs.isEmpty ? null : projs;
  }

  Future<List<Map<String, dynamic>>?> _fetchProjectsFromWeb() async {
    log("Fetch dati progetti");
    List<Map<String, dynamic>>? projFromWeb;

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

    return dbProvider.getBoundariesTreeValues();
  }

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

  Future<Statistics> _calculateStats() async {
    List<Tree> trees = await dbProvider.getUserTrees(currentUserId);

    int totCo2 = _getTotalOn((e) => (e as Tree).co2, trees).toInt();
    int totalHeight = _getTotalOn((e) => (e as Tree).height, trees).toInt();

    double petrolOilLiter = ValueConverter.fromCo2ToPetrolLiter(totCo2);
    int petrolBarrels = ValueConverter.fromPetrolLiterToBarrels(petrolOilLiter);
    int kiloWattHours =
        ValueConverter.fromPetrolToKiloWatt(petrolOilLiter).toInt();

    var userProject = await dbProvider.getUserProjects(currentUserId);
    int papers = userProject.isNotEmpty
        ? userProject.map((e) => e.paper).reduce((val, e) => val += e).toInt()
        : 0;

    var unlockedBadge = await dbProvider.getUserBadges(currentUserId);

    double progressPerc = double.parse(
        ((unlockedBadge.length / appBadges.length) * 100)
            .toString()
            .substring(0, 5));

    return Statistics(
      papers,
      totCo2,
      totalHeight,
      petrolBarrels,
      kiloWattHours,
      progressPerc,
    );
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
    Set<int> userBadges = await dbProvider.getUserBadges(currentUserId);

    if (userBadges.isEmpty) {
      //add first badge (idBadge = 1)
      dbProvider.addUserBadge(currentUserId, 1);
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
    notifyListeners();
  }

  Future<Map<InfoType, dynamic>?> isValidTreeCode(String qrData) async {
    log("isValidtreeCode Called");
    var treeId = int.parse(qrData);

    Tree? tree = await dbProvider.getTree(treeId);
    Project? proj = await dbProvider.getProject(treeId);
    List<Tree> userTrees = await dbProvider.getUserTrees(currentUserId);
    bool isNewTree = userTrees.where((tree) => tree.treeId == treeId).isEmpty;
    log("Albero: ${tree == null ? 'Null' : 'presente'}");
    log("Progetto: ${proj == null ? 'Null' : 'presente'}");

    Map<TreeSpecs, Pair<num, num>> treeMaxValues = await getBoundsOfTreeVal();

    if (tree != null && proj != null) {
      if (isNewTree) {
        unlockUserBadge();
        addUserTree(treeId);
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
}