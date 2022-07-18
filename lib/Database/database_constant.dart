//database constants
import 'dataModel.dart';

const int DEFAULT_USER_ID = 0;
const String databaseDDLfile = "assets/TreeAR.ddl";

const userTreeTable = "UserTree";
const userBadgeTable = "UserBadge";
const userTable = "UserProfile";
const projectTable = "Project";
const treeTable = "Tree";

var defaultUser = User(
  userId: DEFAULT_USER_ID,
  name: "Nome",
  surname: "cognome",
  dateBirth: "Data di nascita",
  course: "Corso universitario",
  registrationDate: "data Immatric.",
  userImageName: "userPlaceholder.jpeg",
);
