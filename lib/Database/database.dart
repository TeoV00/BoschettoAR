import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dataModel.dart';
import 'database_constant.dart';

class DatabaseProvider {
  DatabaseProvider._();

  //Singleton pattern
  static final DatabaseProvider dbp = DatabaseProvider._();
  static Database? _database;

  DatabaseProvider() {
    _createDatabase();
    print("construcotr _databse is null = ${_database == null}");
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
      join(path, 'treyyhhw.db'),
      version: 1, //--> use oncreate
      onCreate: (db, version) async {
        //I tried to use a for-statement but queries ar not interpreted correctly
        //i dont like it
        db.execute(creationQuery[0]); //UserProfile
        db.execute(creationQuery[1]); //project
        db.execute(creationQuery[2]); //Badge
        db.execute(creationQuery[3]); //UserTrees
        db.execute(creationQuery[4]); //UserBadge
        db.execute(creationQuery[5]); //Tree
        //insert default empty user profile
        _insert(db, userTable, defaultUser);
        _insert(
            db,
            treeTable,
            Tree(
                treeId: 1,
                name: "AlberoBello",
                descr: "descr",
                height: 100,
                diameter: 10,
                co2: 203));
        _insert(
            db,
            projectTable,
            Project(
                projectId: 1,
                treeId: 1,
                name: "name",
                descr: "descr",
                link: "link"));
        _insert(
            db,
            treeTable,
            Tree(
                treeId: 2,
                name: "pinkopalla",
                descr: "descr",
                height: 100,
                diameter: 10,
                co2: 203));
        _insert(
            db,
            projectTable,
            Project(
                projectId: 2,
                treeId: 2,
                name: "progetto 2",
                descr:
                    "bellissimo progetto di sostenibilita delle cicale in sede",
                link: "link"));

        for (var bd in badges) {
          _insert(db, badgeTable, bd);
        }
        // _insert(db, badgeTable,
        //     Badge(id: 1, descr: "Pollicino verde", imageName: "badge1.png"))
      },
    );
  }

  void insertTree(Tree tree) {
    if (_database != null) {
      _insert(_database!, treeTable, tree);
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
    String? name,
    String? surname,
    String? dateBirth,
    String? course,
    String? registrationDate,
    String? userImageName,
  ) async {
    var result = 0;
    var usr = await getUserInfo(userId);
    // print(usr.toString());

    if (database != null && usr != null) {
      var db = await database;
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

  Future<List<Badge>> getUserBadges(int userId) async {
    List<Badge> userBadges = List.empty(growable: true);
    var db = await database;
    var result = await db.query(
      userBadgeTable,
      where: "userId = ?",
      whereArgs: [userId],
    );

    userBadges = result.map((e) => Badge.fromMap(e)).toList();

    return userBadges;
  }

  Future<List<Badge>> getAllBadges() async {
    List<Badge> badges = List.empty(growable: true);
    var db = await database;
    var result = await db.query(
      badgeTable,
    );
    badges = result.map((e) => Badge.fromMap(e)).toList();

    return badges;
  }

  static bool isNull(dynamic elem) {
    return elem == null;
  }

  //true --> transaction goes done
  //false --> somethings goes wrong
  Future<bool> _insert(
    Database db,
    String tableName,
    ObjToMapI objToInsert,
  ) async {
    var result = 0; //not inserted
    result = await db.insert(
      tableName,
      objToInsert.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return result != 0;
  }
}
