import 'package:tree_ar/DataModel/obj2map.dart';

class SharedData implements ObjToMapI {
  final int badgeCount;
  final int co2;
  final int level;
  final int paper;
  final int treesCount;
  final String nickname;

  SharedData({
    required this.nickname,
    required this.badgeCount,
    required this.co2,
    required this.level,
    required this.paper,
    required this.treesCount,
  });

  factory SharedData.fromMap({
    required Map<String, dynamic> data,
  }) {
    return SharedData(
      nickname: data['nickname'],
      badgeCount: data['badgeCount'],
      co2: data['co2'],
      level: data['level'],
      paper: data['paper'],
      treesCount: data['treesCount'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'badgeCount': badgeCount,
      'co2': co2,
      'level': level,
      'paper': paper,
      'treesCount': treesCount,
    };
  }
}
