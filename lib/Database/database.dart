import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dataModel.dart';
import 'package:flutter/services.dart';
import 'database_constant.dart';

class DatabaseProvider {
  DatabaseProvider._();
  //Singleton pattern
  static final DatabaseProvider dbp = DatabaseProvider._();
  static late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _createDatabase();
    return _database;
  }

  ///method to create database tables from file ddl generated from db-main
  ///all tables are created
  Future<Database> _createDatabase() async {
    String creationQuery = await rootBundle.loadString(databaseDDLfile);

    return openDatabase(
      join(await getDatabasesPath(), 'TreeArData.db'),
      onCreate: ((db, version) {
        db.execute(creationQuery);
        //create userProfile
        db.insert(
          userTable,
          User(
            userId: DEFAULT_USER_ID,
            name: "Nome",
            surname: "cognome",
            dateBirth: "Data di nascita",
            course: "Corso universitario",
            registrationDate: "data Immatric.",
            userImageName: "userPlaceholder.jpeg",
          ).toMap(),
        );
      }),
      version: 1, //--> use oncreate
    );
  }

  ///Save new tree scanned from user
  ///return false for some specific conflict algorithms if not inserted.
  Future<bool> addUserTree(int userId, int treeId) async {
    final db = await database;
    var result = db.insert(
      userTreeTable,
      UserTrees(userId: userId, treeId: treeId).toMap(),
    );
    return result != 0;
  }

  ///Add new badge that user unlocked
  ///return false for some specific conflict algorithms if not inserted.
  Future<bool> addUserBadge(int userId, int idBadge) async {
    final db = await database;
    var result = db.insert(
      userBadgeTable,
      UserBadge(userId: userId, idBadge: idBadge).toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
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

//VOLENDO RITORNO UNA MAPPA CON CHIAVI InfoType.trees InfoType.project e poi gli array corrispondenti
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
