//database constants
import 'data_model.dart';

const int defaultUserId = 0;
const String databaseDDLfile = "assets/TreeAR.ddl";

const userTreeTable = "UserTrees";
const userBadgeTable = "UserBadge";
const userTable = "UserProfile";
const projectTable = "Project";
const treeTable = "Tree";
const badgeTable = "Badge";

var defaultUser = User(
  userId: defaultUserId,
  name: "Nome",
  surname: "Cognome",
  dateBirth: "gg/mm/aaaa",
  course: "Corso universitario",
  registrationDate: "xxxx",
  userImageName: null,
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
     projectId INTEGER PRIMARY KEY,
     treeId INTEGER,
     projectName TEXT,
     category TEXT,
     descr TEXT,
     paper REAL,
     treesCount REAL,
     years INTEGER,
     co2Saved REAL);''',
  //2
  '''CREATE TABLE Badge (
     id INTEGER PRIMARY KEY,
     descr TEXT,
     imageName TEXT);''',
  //3
  '''CREATE TABLE UserTrees (
     userId INTEGER,
     treeId INTEGER,
     PRIMARY KEY (userId, treeId));''',
  //4
  '''CREATE TABLE UserBadge (
     idBadge INTEGER,
     userId INTEGER,
     PRIMARY KEY (idBadge, userId));''',
  //5
  '''CREATE TABLE Tree (
     treeId INTEGER PRIMARY KEY,
     name TEXT,
     descr TEXT,
     height INTEGER,
     diameter INTEGER,
     co2 INTEGER,
     imgUrl TEXT);''',
];

//List of badge
List<Badge> appBadges = [
  Badge(id: 1, descr: "Buon inizio", imageName: "badge1.png"),
  Badge(
      id: 2,
      descr: "Un piccolo passo per l'uomo un grande passo per l'ambiente",
      imageName: "badge2.png"),
  Badge(id: 3, descr: "Sei un boss", imageName: "badge3.png"),
  Badge(id: 4, descr: "Quante piante!", imageName: "badge4.png"),
  Badge(id: 5, descr: "Sei diventato un fan!", imageName: "badge5.png"),
  Badge(id: 6, descr: "Sei un boss", imageName: "badge6.png"),
  Badge(id: 7, descr: "Quante piante!", imageName: "badge7.png"),
  Badge(id: 8, descr: "Sei diventato un fan!", imageName: "badge8.png"),
  Badge(id: 9, descr: "Sei un boss", imageName: "badge9.png"),
  Badge(id: 10, descr: "Quante piante!", imageName: "badge10.png"),
  Badge(id: 11, descr: "Sei diventato un fan!", imageName: "badge11.png"),
  Badge(id: 12, descr: "Sei un boss", imageName: "badge12.png"),
  Badge(id: 13, descr: "Quante piante!", imageName: "badge13.png"),
  Badge(id: 14, descr: "Sei diventato un fan!", imageName: "badge14.png"),
];
