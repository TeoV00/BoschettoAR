//database constants
import 'package:tree_ar/constant_vars.dart';

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

Map<String, String> categoryImage = {
  "Dematerializzazione": "$categoriesImagePath/dematerialization.png",
  "Comunicazione Digitale": "$categoriesImagePath/digit_communication.png",
  "Innovazione del Processo": "$categoriesImagePath/innovation.png",
};

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
  Badge(
      id: 1,
      descr: "Il primo albero non si scorda mai!",
      imageName: "badge1.png"),
  Badge(
      id: 2,
      descr: "Un piccolo passo per l'uomo un grande passo per l'ambiente",
      imageName: "badge2.png"),
  Badge(id: 3, descr: "Non c'è due senza tre", imageName: "badge3.png"),
  Badge(id: 4, descr: 'Medaglia "Eroe degli alberi"', imageName: "badge4.png"),
  Badge(
      id: 5,
      descr: "Un piccolo gesto fa la differenza",
      imageName: "badge5.png"),
  Badge(id: 6, descr: "Sei un boss", imageName: "badge6.png"),
  Badge(id: 7, descr: "Non mollare, sei a metà!", imageName: "badge7.png"),
  Badge(id: 8, descr: "Sei diventato un fan!", imageName: "badge8.png"),
  Badge(
      id: 9,
      descr: 'Medaglia "Risparmiatore di carta"',
      imageName: "badge9.png"),
  Badge(
      id: 10,
      descr: 'Medaglia "Amante della natura"',
      imageName: "badge10.png"),
  Badge(
      id: 11,
      descr: "Grazie agli alberi si sta più freschi",
      imageName: "badge11.png"),
  Badge(id: 12, descr: "Ora l'aria è più pulita", imageName: "badge12.png"),
  Badge(id: 13, descr: "Quanti alberi!", imageName: "badge13.png"),
  Badge(id: 14, descr: "Sei diventato un master", imageName: "badge14.png"),
];
