//File containing all classes that correspond to entities/tables in db

import 'dart:developer';

class Tree implements ListItemInterface, ObjToMapI {
  final int treeId;
  final String name;
  final String descr;
  final int height;
  final int diameter;
  final int co2;
  final String? imgUrl;

  Tree(
      {required this.treeId,
      required this.name,
      required this.descr,
      required this.height,
      required this.diameter,
      required this.co2,
      this.imgUrl});

  @override
  Map<String, dynamic> toMap() {
    return {
      'treeId': treeId,
      'name': name,
      'descr': descr,
      'height': height,
      'diameter': diameter,
      'co2': co2,
      'imgUrl': imgUrl
    };
  }

  factory Tree.fromMap(Map<String, dynamic> treeDb) {
    return Tree(
        treeId: treeDb['treeId'],
        name: treeDb['name'],
        descr: treeDb['descr'],
        height: treeDb['height'],
        diameter: treeDb['diameter'],
        co2: treeDb['co2'],
        imgUrl: treeDb['imgUrl']);
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
  final String projectName; //projectName from json file
  final String descr; //description from json
  final double treesCount; // trees from json
  final int years;
  final String category;
  final double paper;
  final double co2Saved;

  Project(
      {required this.projectId,
      required this.treeId,
      required this.projectName,
      required this.category,
      required this.descr,
      required this.paper,
      required this.treesCount,
      required this.years,
      required this.co2Saved});

  @override
  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'treeId': treeId,
      'projectName': projectName,
      'category': category,
      'descr': descr,
      'paper': paper,
      'treesCount': treesCount,
      'years': years,
      'co2Saved': co2Saved
    };
  }

  factory Project.fromMap(Map<String, dynamic> projectDb) {
    return Project(
      projectId: projectDb['projectId'],
      treeId: projectDb['treeId'],
      projectName: projectDb['projectName'],
      descr: projectDb['descr'],
      paper: projectDb['paper'],
      category: projectDb['category'],
      treesCount: projectDb['treesCount'],
      years: projectDb['years'],
      co2Saved: projectDb['co2Saved'],
    );
  }

  @override
  String getDescr() {
    return descr;
  }

  @override
  String getTitle() {
    return projectName;
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
  String? name;
  String? surname;
  String? dateBirth;
  String? course;
  String? registrationDate;
  String? userImageName;

  User(
      {required this.userId,
      this.name,
      this.surname,
      this.dateBirth,
      this.course,
      this.registrationDate,
      this.userImageName});

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
        userImageName: userDb['userImageName']);
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
