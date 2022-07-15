import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dataModel.dart';
import 'package:flutter/services.dart';

const String databaseDDLfile = "assets/TreeAR.ddl";

class DatabaseHelper {
  late Future<Database> database;

  DatabaseHelper() {
    database = _createDatabase();
  }

  ///method to create database tables
  Future<Database> _createDatabase() async {
    String creationQuery = await rootBundle.loadString(databaseDDLfile);
    print(creationQuery);

    return openDatabase(
      join(await getDatabasesPath(), 'TreeArData.db'),
      onCreate: ((db, version) {
        return db.execute(creationQuery);
      }),
      version: 1, //--> use oncreate
    );
  }

  // ///sample code to get record entity
  // Future<List<Tree>> dogs() async {
  //   // Get a reference to the database.
  //   final db = await database;

  //   // Query the table for all The Dogs.
  //   final List<Map<String, dynamic>> maps = await db.query('tree');

  //   // Convert the List<Map<String, dynamic> into a List<Dog>.
  //   return List.generate(maps.length, (i) {
  //     return (
  //       id: maps[i]['id'],
  //       name: maps[i]['name'],
  //       age: maps[i]['age'],
  //     );
  //   });
  // }
}
