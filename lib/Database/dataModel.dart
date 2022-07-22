//File containing all classes that correspond to entities/tables in db

class Tree implements ListItemInterface, ObjToMapI {
  final int treeId;
  final String name;
  final String descr;
  final int height;
  final int diameter;
  final int co2;

  Tree(
      {required this.treeId,
      required this.name,
      required this.descr,
      required this.height,
      required this.diameter,
      required this.co2});

  @override
  Map<String, dynamic> toMap() {
    return {
      'treeId': treeId,
      'name': name,
      'descr': descr,
      'height': height,
      'diameter': diameter,
      'co2': co2,
    };
  }

  factory Tree.fromMap(Map<String, dynamic> treeDb) {
    return Tree(
        treeId: treeDb['treeId'],
        name: treeDb['name'],
        descr: treeDb['descr'],
        height: treeDb['height'],
        diameter: treeDb['diameter'],
        co2: treeDb['co2']);
  }

  @override
  String getDescr() {
    return descr;
  }

  @override
  String getTitle() {
    return name;
  }
}

class Project implements ListItemInterface, ObjToMapI {
  final int projectId;
  final int treeId;
  final String name;
  final String descr;
  final String link;

  Project(
      {required this.projectId,
      required this.treeId,
      required this.name,
      required this.descr,
      required this.link});

  @override
  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'treeId': treeId,
      'name': name,
      'descr': descr,
      'link': link
    };
  }

  factory Project.fromMap(Map<String, dynamic> projectDb) {
    return Project(
        projectId: projectDb['projectId'],
        treeId: projectDb['treeId'],
        name: projectDb['name'],
        descr: projectDb['descr'],
        link: projectDb['link']);
  }

  @override
  String getDescr() {
    return descr;
  }

  @override
  String getTitle() {
    return name;
  }
}

class Badge implements ObjToMapI {
  final int id;
  final String descr;
  final String imageName;
  Badge({required this.id, required this.descr, required this.imageName});

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descr': descr,
      'imageName': imageName,
    };
  }

  factory Badge.fromMap(Map<String, dynamic> badgeDb) {
    return Badge(
      id: badgeDb['id'],
      descr: badgeDb['descr'],
      imageName: badgeDb['imageName'],
    );
  }
}

class User implements ObjToMapI {
  final int userId;
  final String? name;
  final String? surname;
  final String? dateBirth; //Date
  final String? course; // varchar(50) not null,
  final String? registrationDate; // date not null,
  final String? userImageName; //varchar(20) not null --,
// --     check(exists(select * from userBadge
// --                  where userBadge.userId = userId))

// userId INTEGER PRIMARY KEY,
//      name TEXT,
//      surname TEXT,
//      dateBirth TEXT ,
//      course TEXT,
//      registrationDate TEXT,
//      userImageName TEXT );
  User(
      {required this.userId,
      required this.name,
      required this.surname,
      required this.dateBirth,
      required this.course,
      required this.registrationDate,
      required this.userImageName});

  @override
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

  String getNameSurname() {
    var name = this.name != null ? this.name! : "Name";
    var surname = this.surname != null ? this.surname! : "Surname";
    return "${name[0].toUpperCase()}${name.substring(1)} ${surname[0].toUpperCase()}${surname.substring(1)}";
  }

  @override
  String toString() {
    return "$name $surname $course $dateBirth $registrationDate $userImageName";
  }
}

class UserTrees implements ObjToMapI {
  final int userId; //numeric(5) not null,
  final int treeId; //numeric(4) not null,
  //constraint IDhasScanned primary key (treeId, userId),
  //foreign key (treeId) references Tree,
  //foreign key (userId) references User);

  UserTrees({required this.userId, required this.treeId});

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'treeId': treeId,
    };
  }

  factory UserTrees.fromMap(Map<String, dynamic> userTreeDb) {
    return UserTrees(
      userId: userTreeDb['userId'],
      treeId: userTreeDb['treeId'],
    );
  }
}

class UserBadge implements ObjToMapI {
  final int userId; //numeric(5) not null,
  final int idBadge; //numeric(4) not null,
//      constraint IDunlocked primary key (idBadge, userId),
//      foreign key (userId) references User,
//      foreign key (idBadge) references Badge);

  UserBadge({required this.userId, required this.idBadge});

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'idBadge': idBadge,
    };
  }

  factory UserBadge.fromMap(Map<String, dynamic> userTreeDb) {
    return UserBadge(
      userId: userTreeDb['userId'],
      idBadge: userTreeDb['idBadge'],
    );
  }
}

abstract class ListItemInterface {
  String getTitle();
  String getDescr();
}

abstract class ObjToMapI {
  Map<String, dynamic> toMap();
}
