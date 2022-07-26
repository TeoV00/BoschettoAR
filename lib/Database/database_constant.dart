//database constants
import 'dataModel.dart';

const int DEFAULT_USER_ID = 0;
const String databaseDDLfile = "assets/TreeAR.ddl";

const userTreeTable = "UserTree";
const userBadgeTable = "UserBadge";
const userTable = "UserProfile";
const projectTable = "Project";
const treeTable = "Tree";
const badgeTable = "Badge";

var defaultUser = User(
  userId: DEFAULT_USER_ID,
  name: "Default",
  surname: "cognome",
  dateBirth: "Data di nascita",
  course: "Corso universitario",
  registrationDate: "data Immatric.",
  userImageName: "userPlaceholder.jpeg",
);

//list of SQL query for creation of tables in db
List<String> creationQuery = [
  //0
  '''CREATE TABLE UserProfile (
     userId INTEGER PRIMARY KEY,
     name TEXT,
     surname TEXT,
     dateBirth TEXT ,
     course TEXT,
     registrationDate TEXT,
     userImageName TEXT );''',
  //1
  '''CREATE TABLE Project (
     name TEXT,
     projectId INTEGER PRIMARY KEY,
     treeId INTEGER,
     descr TEXT,
     link TEXT );''',
  //2
  '''CREATE TABLE Badge (
     id INTEGER PRIMARY KEY,
     descr TEXT,
     imageName TEXT);''',
  //3
  '''CREATE TABLE UserTrees (
     userId INTEGER,
     treeId INTEGER);''',
  //4
  '''CREATE TABLE UserBadge (
     idBadge INTEGER,
     userId INTEGER );''',
  //5
  '''CREATE TABLE Tree (
     treeId INTEGER PRIMARY KEY,
     name TEXT,
     descr TEXT,
     height INTEGER,
     diameter INTEGER,
     co2 INTEGER );''',
];
