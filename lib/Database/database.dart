import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dataModel.dart';
import 'database_constant.dart';

class DatabaseProvider {
  //Singleton pattern
  static final DatabaseProvider dbp = DatabaseProvider();
  static Database? _database;

  DatabaseProvider() {
    _createDatabase();
  }

  Database? get database {
    if (_database == null) {
      _createDatabase();
    }
    return _database;
  }

  ///method to create database tables from file ddl generated from db-main
  ///all tables are created
  void _createDatabase() async {
    var path = await getDatabasesPath();

    _database = await openDatabase(
      join(path, 'treeAR.db'),
      version: 1, //--> use oncreate
      onCreate: (db, version) {
        //var tablesCount = creationQuery.length;
        //for (var i = 0; i < tablesCount; i++) {
        db.execute(creationQuery[0]);
        db.execute(creationQuery[5]);
        //}
        //insert default empty user profile
        db.insert(
          userTable,
          defaultUser.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort,
        );
      },
    );

    //for debug insert tree with id = 1
    database!.insert(
      treeTable,
      Tree(
              treeId: 0,
              name: "name",
              descr: "descr",
              height: 122,
              diameter: 40,
              co2: 40)
          .toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  ///Save new tree scanned from user
  ///return false for some specific conflict algorithms if not inserted.
  Future<bool> addUserTree(int userId, int treeId) async {
    var result = 0;
    if (database != null) {
      var db = database!;
      db
          .insert(
            userTreeTable,
            UserTrees(userId: userId, treeId: treeId).toMap(),
          )
          .then((value) => {result = value});
    }

    return result != 0;
  }

  ///Add new badge that user unlocked
  ///return false for some specific conflict algorithms if not inserted.
  Future<bool> addUserBadge(int userId, int idBadge) async {
    int result = 0; //by default: insert query not done
    if (database != null) {
      var db = database!;
      db
          .insert(
            userBadgeTable,
            UserBadge(userId: userId, idBadge: idBadge).toMap(),
            conflictAlgorithm: ConflictAlgorithm.abort,
          )
          .then((value) => {result = value});
    }

    return result != 0;
  }

  ///update user information
  //if result greather than 0 means that operation has gone done
  //else nothing has been changed
  Future<bool> updateUserInfo(
    int userId,
    String? name,
    String? surname,
    String? dateBirth,
    String? course,
    String? registrationDate,
    String? userImageName,
  ) async {
    var result = 0;
    var usr = await getUserInfo(userId);

    if (database != null && usr != null) {
      var db = database!;
      result = await db.update(
          userTable,
          User(
            userId: userId,
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
    return result > 0;
  }

  ///it return null if the specified user by id doesn't exist
  Future<User?> getUserInfo(int userId) async {
    User? result;
    if (database != null) {
      var db = database!;
      var resultQuery = await db.query(
        userTable,
        where: "userId = ?",
        whereArgs: [userId],
      );
      result = resultQuery.isNotEmpty ? User.fromMap(resultQuery.first) : null;
    }
    return result;
  }

  Future<List<Tree>> getUserTrees(int userId) async {
    List<Tree> userTrees = List.empty(growable: true);
    if (database != null) {
      var db = database!;
      var result = await db.query(
        userTreeTable,
        where: "userId = ?",
        whereArgs: [userId],
      );

      for (var element in result) {
        Tree tree = Tree.fromMap(element);
        userTrees.add(tree);
      }
    }
    return userTrees;
  }

  Future<Tree?> getTree(int treeId) async {
    if (database != null) {
      var db = database!;
      var result = await db.query(
        treeTable,
        where: "treeId = ?",
        whereArgs: [treeId],
      );
      return Tree.fromMap(result.first);
    }
    return null;
  }

  Future<Project?> getProject(int treeId) async {
    if (database != null) {
      var db = database!;
      var result = await db.query(
        projectTable,
        where: "treeId = ?",
        whereArgs: [treeId],
      );
      return Project.fromMap(result.first);
    }
    return null;
  }

  Future<List<Project>> getUserProjects(int userId) async {
    //get all projects where treeId is in list
    final treeIds = (await getUserTrees(userId)).map((e) => e.treeId).toSet();
    List<Project> userProject = List.empty(growable: true);
    if (database != null) {
      var db = database!;
      var result = await db.query(
        projectTable,
        where: "treeId IN (${treeIds.join(', ')})",
      );

      for (var element in result) {
        Project projc = Project.fromMap(element);
        userProject.add(projc);
      }
    }

    return userProject;
  }

  Future<List<Badge>> getUserBadges(int userId) async {
    List<Badge> userBadges = List.empty(growable: true);
    if (database != null) {
      var db = database!;
      var result = await db.query(
        userBadgeTable,
        where: "userId = ?",
        whereArgs: [userId],
      );

      for (var element in result) {
        Badge badge = Badge.fromMap(element);
        userBadges.add(badge);
      }
    }
    return userBadges;
  }

  ///if result list is not empty means that there is a tree with the given treeId
  Future<bool> isValidTree(int id) async {
    List<Map<String, dynamic>> result = List.empty();
    if (database != null) {
      var db = database!;
      //get treeId that match the given treeId
      result = await db.query(treeTable, where: "treeId = ?", whereArgs: [id]);
    }
    return result.isNotEmpty;
  }

  static bool isNull(dynamic elem) {
    return elem == null;
  }
}
