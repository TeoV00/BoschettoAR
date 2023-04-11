import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_ar/constant_vars.dart';

class BottomGrass extends StatelessWidget {
  final Widget child;
  final Widget? childOnGrass;
  const BottomGrass({super.key, required this.child, this.childOnGrass});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Flex(
            direction: Axis.vertical,
            children: [
              Expanded(child: child),
            ],
          ),
          LayoutBuilder(
            builder: ((context, constraints) {
              var parentWidth = constraints.maxWidth;
              return SizedBox(
                width: parentWidth,
                height: grassHeight,
                child: SvgPicture.asset(
                  '$imagePath/grass.svg',
                  color: mainColor,
                  excludeFromSemantics: true,
                  fit: BoxFit.fill,
                ),
              );
            }),
          ),
          if (childOnGrass != null) ...[childOnGrass!],
        ],
      ),
    );
  }
}
