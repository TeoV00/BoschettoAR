//File containing all classes that correspond to entities/tables in db

class Tree {
  final int id;
  final String name;
  final String descr;
  final int height;

  Tree(
      {required this.id,
      required this.name,
      required this.descr,
      required this.height});
}

class Project {
  final int projectId;
  final String name;
  final String descr;

  Project({required this.projectId, required this.name, required this.descr});
}
