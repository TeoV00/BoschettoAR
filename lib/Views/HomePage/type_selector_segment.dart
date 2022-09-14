import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';

class TypeSelector extends StatefulWidget {
  final double segmentWidth;
  final State<TypeSelector> state = _TypeSelectorState();
  TypeSelector({super.key, required this.segmentWidth});

  @override
  State<StatefulWidget> createState() => state;
}

class _TypeSelectorState extends State<TypeSelector> {
  InfoType selectedType = InfoType.tree;

  InfoType getSelectedType() {
    return selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(radiusCorner), color: secondColor),
          height: 50,
          width: topSectionTabWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ChoiceChip(
                label: SizedBox(
                  width: widget.segmentWidth,
                  child: const Text(
                    "Alberi",
                    textAlign: TextAlign.center,
                  ),
                ),
                selected: selectedType == InfoType.tree,
                onSelected: (_) => _onTapTab(InfoType.tree),
                selectedColor: Colors.white,
              ),
              ChoiceChip(
                label: SizedBox(
                  width: widget.segmentWidth,
                  child: const Text(
                    "Progetti",
                    textAlign: TextAlign.center,
                  ),
                ),
                selected: selectedType == InfoType.project,
                onSelected: (_) => _onTapTab(InfoType.project),
                selectedColor: Colors.white,
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onTapTab(InfoType typeSelected) {
    setState(() {
      selectedType = typeSelected;
    });
  }
}
