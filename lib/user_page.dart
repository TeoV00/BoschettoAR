import 'package:flutter/material.dart';
import 'main.dart';

class BadgeCircle extends StatelessWidget {
  final String badgeImage;
  final bool isActive;

  const BadgeCircle(
      {Key? key, required this.badgeImage, required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? secondColor : disableBadge,
      ),
      child: Text(isActive.toString()), //TODO: put badge img
    );
  }
}
