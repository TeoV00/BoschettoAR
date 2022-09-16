import 'package:flutter/material.dart';
import 'package:tree_ar/Database/data_model.dart';
import 'package:tree_ar/Utils/circle_online_image.dart';
import 'package:tree_ar/constant_vars.dart';

class RowItem extends StatelessWidget {
  final ListItemInterface item;
  final InfoType type;

  static const margin5H = EdgeInsets.symmetric(horizontal: 5);

  const RowItem({Key? key, required this.item, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 85,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: grayColor,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: type == InfoType.project
                ? RoundImage(
                    defaultWidget: Image.asset(defaultItemImage[type]!),
                    size: 75,
                    assetPath: item.getImageUrl(),
                  )
                : RoundImage(
                    defaultWidget: Image.asset(defaultItemImage[type]!),
                    size: 75,
                    url: item.getImageUrl(),
                  ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(
                  direction: Axis.vertical,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        item.getTitle(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.vertical,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        item.getDescr(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
