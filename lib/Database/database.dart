import 'dart:async';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tree_ar/DataModel/obj2map.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/utils.dart';
import '../DataModel/data_model.dart';
import 'database_constant.dart';

class DatabaseProvider {
  DatabaseProvider._();

  //Singleton pattern
  static final DatabaseProvider dbp = DatabaseProvider._();
  static Database? _database;

  DatabaseProvider() {
    _createDatabase();
    log("construcotr _databse is null = ${_database == null}");
  }

  Future<Database> get database async {
    _database ??= await _createDatabase();
    return _database!;
  }

  ///method to create database tables from file ddl generated from db-main
  ///all tables are created
  Future<Database> _createDatabase() async {
    var path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'demo_firebase2.db'),
      version: 1, //--> use oncreate
      onCreate: (db, version) async {
        //I tried to use a for-statement but queries ar not interpreted correctly
        //i dont like it
        Batch batch = db.batch();

        batch.execute(creationQuery[0]); //UserProfile
        batch.execute(creationQuery[1]); //project
        batch.execute(creationQuery[2]); //Badge
        batch.execute(creationQuery[3]); //UserTrees
        batch.execute(creationQuery[4]); //UserBadge
        batch.execute(creationQuery[5]); //Tree

        batch.commit(noResult: true);

        //insert default empty user profile
        _insert(db, userTable, defaultUser);

        for (var bd in appBadges) {
          batch.insert(badgeTable, bd.toMap(),
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      },
    );
  }

  void insertTree(Tree tree) {
    if (_database != null) {
      _insert(_database!, treeTable, tree);
    }
  }

  void insertProject(Project proj) {
    if (_database != null) {
      _insert(_database!, projectTable, proj);
    }
  }

  ///Save new tree scanned from user
  ///return false for some specific conflict algorithms if not inserted.
  Future<bool> addUserTree(int userId, int treeId) async {
    if (_database != null) {
      return _insert(
        _database!,
        userTreeTable,
        UserTrees(userId: userId, treeId: treeId),
      );
    } else {
      return false;
    }
  }

  ///Add new badge that user unlocked
  ///return false for some specific conflict algorithms if not inserted.
  Future<bool> addUserBadge(int userId, int idBadge) async {
    if (_database != null) {
      return _insert(
        _database!,
        userBadgeTable,
        UserBadge(userId: userId, idBadge: idBadge),
      );
    } else {
      return false;
    }
  }

  ///update user information
  //if result greather than 0 means that operation has gone done
  //else nothing has been changed
  Future<bool> updateUserInfo(
    int userId,
    String? nickname,
    String? name,
    String? surname,
    String? dateBirth,
    String? course,
    String? registrationDate,
    String? userImageName,
  ) async {
    var result = 0;
    var usr = await getUserInfo(userId);

    if (usr != null) {
      var db = await database;
      String? newNickname;
      if (isNull(usr.nickname) && !isNull(nickname)) {
        newNickname = nickname;
      } else if (!isNull(usr.nickname)) {
        newNickname = usr.nickname;
      }
      result = await db.update(
          userTable,
          User(
            userId: userId,
            nickname: newNickname,
            name: isNull(name) ? usr.name : name!,
            surname: isNull(surname) ? usr.surname : surname!,
            dateBirth: isNull(dateBirth) ? usr.dateBirth : dateBirth!,
            course: isNull(course) ? usr.course : course!,
            registrationDate: isNull(registrationDate)
                ? usr.registrationDate
                : registrationDate!,
            userImageName:
                isNull(userImageName) ? usr.userImageName : userImageName!,
          ).toMap());
    }
    // print(result);
    return result > 0;
  }

  ///it return null if the specified user by id doesn't exist
  Future<User?> getUserInfo(int userId) async {
    User? result;
    var db = await database;
    var resultQuery = await db.query(
      userTable,
      where: "userId = ?",
      whereArgs: [userId],
    );
    result = resultQuery.isNotEmpty ? User.fromMap(resultQuery.first) : null;
    return result;
  }

  Future<Map<TreeSpecs, Pair<num, num>>> getBoundariesTreeValues() async {
    num maxCo2 = await _getTreeMaxValueOf('co2', treeTable);
    num maxPaper = await _getTreeMaxValueOf('paper', projectTable);
    num maxHeight = await _getTreeMaxValueOf('height', treeTable);
    num maxDiameter = await _getTreeMaxValueOf('diameter', treeTable);

    num minCo2 = await _getTreeMinValueOf('co2', treeTable);
    num minPaper = await _getTreeMinValueOf('paper', projectTable);
    num minHeight = await _getTreeMinValueOf('height', treeTable);
    num minDiameter = await _getTreeMinValueOf('diameter', treeTable);

    num totPaper = await _getTotalSavedPaper();

    return {
      TreeSpecs.co2: Pair<num, num>(minCo2, maxCo2),
      TreeSpecs.paper: Pair<num, num>(minPaper, maxPaper),
      TreeSpecs.height: Pair<num, num>(minHeight, maxHeight),
      TreeSpecs.diameter: Pair<num, num>(minDiameter, maxDiameter),
      TreeSpecs.maxTemp: Pair<num, num>(0, 0),
      TreeSpecs.minTemp: Pair<num, num>(0, 0),
      TreeSpecs.water: Pair<num, num>(0, 0),
      TreeSpecs.totalPaper: Pair<num, num>(totPaper, totPaper),
    };
  }

  Future<num> _getTotalSavedPaper() async {
    var db = await database;
    var res = await db.rawQuery('SELECT sum(paper) as sum FROM $projectTable');
    return res.isNotEmpty ? res.first.values.first as num : 0;
  }

  Future<num> _getTreeMaxValueOf(String detailType, String table) async {
    var db = await database;
    var res = await db.rawQuery('SELECT max($detailType) FROM $table');

    if (res.isNotEmpty) {
      return num.parse(res.first.values.first.toString());
    } else {
      return 0;
    }
  }

  Future<num> _getTreeMinValueOf(String detailType, String table) async {
    var db = await database;
    var res = await db.rawQuery('SELECT min($detailType) FROM $table');

    if (res.isNotEmpty) {
      return num.parse(res.first.values.first.toString());
    } else {
      return 0;
    }
  }

  Future<List<Tree>> getUserTrees(int userId) async {
    List<Tree> userTrees = List.empty(growable: true);
    var db = await database;
    var result = await db.rawQuery('''SELECT T.* 
          FROM $treeTable as T, $userTreeTable as U 
          WHERE U.userId = $userId
          AND T.treeId = U.treeId
          ''');

    for (var element in result) {
      Tree tree = Tree.fromMap(element);
      userTrees.add(tree);
    }

    return userTrees;
  }

  Future<Tree?> getTree(int treeId) async {
    var db = await database;
    var result = await db.query(
      treeTable,
      where: "treeId = ?",
      whereArgs: [treeId],
    );
    return result.isNotEmpty ? Tree.fromMap(result.first) : null;
  }

  Future<Project?> getProject(int treeId) async {
    var db = await database;
    var result = await db.query(
      projectTable,
      where: "treeId = ?",
      whereArgs: [treeId],
    );
    return result.isNotEmpty ? Project.fromMap(result.first) : null;
  }

  Future<List<Project>> getUserProjects(int userId) async {
    var db = await database;
    //get all projects where treeId is in list
    final treeIds = (await getUserTrees(userId)).map((e) => e.treeId).toSet();
    List<Project> userProject = List.empty(growable: true);

    var result = await db.query(
      projectTable,
      where: "treeId IN (${treeIds.join(', ')})",
    );

    for (var element in result) {
      Project projc = Project.fromMap(element);
      userProject.add(projc);
    }

    return userProject;
  }

  Future<Set<int>> getUserBadges(int userId) async {
    Set<int> userBadges = {};
    var db = await database;
    var result = await db.query(
      userBadgeTable,
      where: "userId = ?",
      whereArgs: [userId],
    );

    userBadges = result.map((e) => e['idBadge'] as int).toSet();
    return userBadges;
  }

  Future<List<GoalBadge>> getAllBadges() async {
    List<GoalBadge> badges = List.empty(growable: true);
    var db = await database;
    var result = await db.query(
      badgeTable,
    );
    badges = result.map((e) => GoalBadge.fromMap(e)).toList();

    return badges;
  }

  static bool isNull(dynamic elem) {
    return elem == null;
  }

  void insertBatchTrees(List<Tree> listObj) {
    _batchInsertion(treeTable, listObj);
  }

  void insertBatchProjects(List<Project> listObj) {
    _batchInsertion(projectTable, listObj);
  }

  ///insert in same atomic transaction a group of object to database
  void _batchInsertion(String tableName, List<ObjToMapI> listObj) async {
    Database db = await database;
    db.transaction(
      (txn) async {
        Batch batch = txn.batch();

        for (var objMap in listObj) {
          batch.insert(tableName, objMap.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
        batch.commit(noResult: true);
      },
    );
  }

  //true --> transaction goes done
  //false --> somethings goes wrong
  Future<bool> _insert(
    Database db,
    String tableName,
    ObjToMapI objToInsert,
  ) async {
    var result = 0; //not inserted
    try {
      result = await db.insert(
        tableName,
        objToInsert.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      log('''Errore inserimento nel db:\n$e''');
    }

    return result != 0;
  }
}
