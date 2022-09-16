import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';

class DetailsBox extends StatelessWidget {
  final String headerTitle;
  final Widget childBox;
  const DetailsBox(
      {Key? key, required this.headerTitle, required this.childBox})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(radiusCorner),
          color: Color.fromARGB(255, 244, 244, 244),
        ),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  children: [
                    Text(
                      headerTitle,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Flex(
                  direction: Axis.vertical,
                  children: [childBox],
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
