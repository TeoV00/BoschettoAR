//File containing all classes that correspond to entities/tables in db

class Tree {
  final int id;
  final String name;
  final String descr;
  final int height;
  final int diameter;
  final int co2;

  Tree(
      {required this.id,
      required this.name,
      required this.descr,
      required this.height,
      required this.diameter,
      required this.co2});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'descr': descr,
      'height': height,
      'diameter': diameter,
      'co2': co2,
    };
  }

  factory Tree.fromMap(Map<String, dynamic> treeDb) {
    return Tree(
        id: treeDb['id'],
        name: treeDb['name'],
        descr: treeDb['descr'],
        height: treeDb['height'],
        diameter: treeDb['diameter'],
        co2: treeDb['co2']);
  }
}

class Project {
  final int projectId;
  final String name;
  final String descr;
  final String link;

  Project(
      {required this.projectId,
      required this.name,
      required this.descr,
      required this.link});

  Map<String, dynamic> toMap() {
    return {'id': projectId, 'name': name, 'descr': descr, 'link': link};
  }

  factory Project.fromMap(Map<String, dynamic> projectDb) {
    return Project(
        projectId: projectDb['projectId'],
        name: projectDb['name'],
        descr: projectDb['descr'],
        link: projectDb['link']);
  }
}

class Badge {
  final int id;
  final String descr;
  Badge({required this.id, required this.descr});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descr': descr,
    };
  }

  factory Badge.fromMap(Map<String, dynamic> badgeDb) {
    return Badge(id: badgeDb['id'], descr: badgeDb['descr']);
  }
}

class User {
  final int userId;
  final String name;
  final String surname;
  final String dateBirth; //Date
  final String course; // varchar(50) not null,
  final String registrationDate; // date not null,
  final String userImageName; //varchar(20) not null --,
// --     check(exists(select * from userBadge
// --                  where userBadge.userId = userId))

  User(
      {required this.userId,
      required this.name,
      required this.surname,
      required this.dateBirth,
      required this.course,
      required this.registrationDate,
      required this.userImageName});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'surname': surname,
      'dateBirth': dateBirth,
      'course': course,
      'registrationDate': registrationDate,
      'userImageName': userImageName
    };
  }

  factory User.fromMap(Map<String, dynamic> userDb) {
    return User(
        userId: userDb['userId'],
        name: userDb['name'],
        surname: userDb['surname'],
        dateBirth: userDb['dateBirth'],
        course: userDb['course'],
        registrationDate: userDb['registrationDate'],
        userImageName: userDb['userImageName)']);
  }
}

// create table userTrees (
//      userId numeric(5) not null,
//      treeId numeric(4) not null,
//      constraint IDhasScanned primary key (treeId, userId),
//      foreign key (treeId) references Tree,
//      foreign key (userId) references User);

// create table userBadge (
//      idBadge numeric(2) not null,
//      userId numeric(5) not null,
//      constraint IDunlocked primary key (idBadge, userId),
//      foreign key (userId) references User,
//      foreign key (idBadge) references Badge);
