import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dataModel.dart';
import 'package:flutter/services.dart';

const String databaseDDLfile = "assets/TreeAR.ddl";

class DatabaseProvider {
  DatabaseProvider._();
  //Singleton pattern
  static final DatabaseProvider db = DatabaseProvider._();
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
        return db.execute(creationQuery);
      }),
      version: 1, //--> use oncreate
    );
  }
}
