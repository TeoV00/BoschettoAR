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

  Project({required this.projectId, required this.name, required this.descr});
}

class Badge {
  final int id;
  final String descr;
  Badge({required this.id, required this.descr});
}
