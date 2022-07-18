import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dataModel.dart';
import 'package:flutter/services.dart';
import 'database_constant.dart';

class DatabaseProvider {
  //Singleton pattern
  static final DatabaseProvider dbp = DatabaseProvider();
  static Database? _database;

  DatabaseProvider() {
    database.then((value) => {_database = value});

    // if (_database != null) {
    //   _database!.insert(
    //     userTable,
    //     defaultUser.toMap(),
    //   );
    // }
  }

  Future<Database> get database async {
    //if not already set create db
    if (_database == null) {
      _createDatabase();
      print("creo db");
    }
    print("uso db gia creato");
    return _database!;
  }

  ///method to create database tables from file ddl generated from db-main
  ///all tables are created
  void _createDatabase() async {
    var path = await getDatabasesPath();
    var creationQuery = await rootBundle.loadString(databaseDDLfile);

    _database = await openDatabase(
      join(path, 'pp.db'),
      version: 1, //--> use oncreate
    );
    print("Db creato");
    if (_database != null) {
      print("creo query raw");
      _database!.rawQuery(creationQuery);
      _database!.insert(userTable, defaultUser.toMap());
    }
  }

  ///Save new tree scanned from user
  ///return false for some specific conflict algorithms if not inserted.
  Future<bool> addUserTree(int userId, int treeId) async {
    final db = await database;
    var result = 0;
    db
        .insert(
          userTreeTable,
          UserTrees(userId: userId, treeId: treeId).toMap(),
        )
        .then((value) => {result = value});
    return result != 0;
  }

  ///Add new badge that user unlocked
  ///return false for some specific conflict algorithms if not inserted.
  Future<bool> addUserBadge(int userId, int idBadge) async {
    final db = await database;
    int result = 0; //by default: insert query not done
    db
        .insert(
          userBadgeTable,
          UserBadge(userId: userId, idBadge: idBadge).toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort,
        )
        .then((value) => {result = value});
    return result != 0;
  }

  ///update user information
  //if result greather than 0 means that operation has gone done
  //else nothing has been changed
  Future<bool> updateUserInfo(
    int userId,
    String name,
    String surname,
    String dateBirth,
    String course,
    String registrationDate,
    String userImageName,
  ) async {
    final db = await database;

    var result = await db.update(
        userTable,
        User(
          userId: userId,
          name: name,
          surname: surname,
          dateBirth: dateBirth,
          course: course,
          registrationDate: registrationDate,
          userImageName: userImageName,
        ).toMap());

    return result > 0;
  }

  Future<User> getUserInfo(int userId) async {
    final db = await database;
    var result = await db.query(
      userTable,
      where: "userId = ?",
      whereArgs: [userId],
    );
    return User.fromMap(result.first);
  }

  Future<List<Tree>> getUserTrees(int userId) async {
    final db = await database;
    var result = await db.query(
      userTreeTable,
      where: "userId = ?",
      whereArgs: [userId],
    );

    List<Tree> userTrees = List.empty(growable: true);
    for (var element in result) {
      Tree tree = Tree.fromMap(element);
      userTrees.add(tree);
    }
    return userTrees;
  }

  Future<Tree> getTree(int treeId) async {
    final db = await database;
    var result = await db.query(
      treeTable,
      where: "treeId = ?",
      whereArgs: [treeId],
    );
    return Tree.fromMap(result.first);
  }

  Future<Project> getProject(int treeId) async {
    final db = await database;
    var result = await db.query(
      projectTable,
      where: "treeId = ?",
      whereArgs: [treeId],
    );
    return Project.fromMap(result.first);
  }

  Future<List<Project>> getUserProjects(int userId) async {
    //get all projects where treeId is in list
    final treeIds = (await getUserTrees(userId)).map((e) => e.treeId).toSet();

    final db = await database;
    var result = await db.query(
      projectTable,
      where: "treeId IN (${treeIds.join(', ')})",
    );

    List<Project> userProject = List.empty(growable: true);
    for (var element in result) {
      Project projc = Project.fromMap(element);
      userProject.add(projc);
    }
    return userProject;
  }

  Future<List<Badge>> getUserBadges(int userId) async {
    final db = await database;
    var result = await db.query(
      userBadgeTable,
      where: "userId = ?",
      whereArgs: [userId],
    );

    List<Badge> userBadges = List.empty(growable: true);
    for (var element in result) {
      Badge badge = Badge.fromMap(element);
      userBadges.add(badge);
    }
    return userBadges;
  }
}
