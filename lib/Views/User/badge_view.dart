import 'package:flutter/material.dart';
import 'package:tree_ar/Database/data_model.dart';
import 'package:tree_ar/constant_vars.dart';

class BadgeContainer extends StatelessWidget {
  const BadgeContainer({Key? key, required this.badges}) : super(key: key);
  final Map<GoalBadge, bool> badges;

  @override
  Widget build(BuildContext context) {
    var entries = badges.entries.toList();
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      padding: const EdgeInsets.symmetric(vertical: 20),
      crossAxisCount: 5,
      children: <Widget>[
        for (var i = 0; i < badges.length; i++) ...[
          BadgeCircle(
              nameDescr: entries[i].key.descr,
              badgeImage: '$badgePath/${entries[i].key.imageName}',
              isActive: entries[i].value),
        ]
      ],
    );
  }
}

class BadgeCircle extends StatelessWidget {
  final String badgeImage;
  final String nameDescr;
  final bool isActive;

  const BadgeCircle(
      {Key? key,
      required this.nameDescr,
      required this.badgeImage,
      required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      message: nameDescr,
      child: ClipOval(
          child: ColorFiltered(
        colorFilter: ColorFilter.mode(
            isActive ? badgeColor : disableBadge, BlendMode.color),
        child: Image.asset(
          badgeImage,
          centerSlice: Rect.largest,
        ),
      )),
    );
  }
}
