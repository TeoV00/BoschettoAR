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
