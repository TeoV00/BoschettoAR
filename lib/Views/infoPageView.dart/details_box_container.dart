import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/data_model.dart';
import 'package:tree_ar/Utils/unit_converter.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/DataProvider/data_manager.dart';
import 'package:tree_ar/utils.dart';

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
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    headerTitle,
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(153, 0, 0, 0)),
                  )),
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

class TreeDetailsBox extends StatelessWidget {
  final Tree tree;
  const TreeDetailsBox({Key? key, required this.tree}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double pad = 10;
    final double screenWidth = MediaQuery.of(context).size.width - (2 * pad);

    return Consumer<DataManager>(
      builder: (context, dataManager, child) {
        return FutureBuilder<Map<TreeSpecs, Pair<num, num>>>(
          future: dataManager.getBoundsOfTreeVal(),
          builder: (context, snapshot) {
            List<Widget> childs;

            if (snapshot.hasData) {
              var bounds = snapshot.data!;

              childs = [
                rowIndicator('Co2/Anno', TreeSpecs.co2, tree.co2,
                    bounds[TreeSpecs.co2]!.elem2, screenWidth),
                rowIndicator('Altezza (m) ', TreeSpecs.height, tree.height,
                    bounds[TreeSpecs.height]!.elem2, screenWidth),
                rowIndicator('Tronco (cm)', TreeSpecs.diameter, tree.diameter,
                    bounds[TreeSpecs.diameter]!.elem2, screenWidth),
              ];
            } else {
              childs = [
                rowLabelValue('Co2', tree.co2.toString(), 'Kg/Anno'),
                rowLabelValue('Altezza', tree.height.toString(), 'm'),
                rowLabelValue('Tronco', tree.diameter.toString(), 'cm'),
              ];
            }

            return DetailsBox(
              headerTitle: 'Dettagli',
              childBox: Column(
                children: childs,
              ),
            );
          },
        );
      },
    );
  }
}

class ProjectDetailsBox extends StatelessWidget {
  final Project proj;
  const ProjectDetailsBox({Key? key, required this.proj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var watt = getMultiplierString(
        ValueConverter.fromCo2ToKiloWatt(proj.co2Saved).toInt());
    return DetailsBox(
      headerTitle: 'Dettagli',
      childBox: Column(
        children: [
          rowLabelValue('Categoria', proj.category.toString(), null),
          rowLabelValue(
              'Anni di Dematerializzazione', proj.years.toString(), null),
          rowLabelValue('Alberi piantati', proj.treesCount.toString(), null),
          rowLabelValue('Carta risparmiata', proj.paper.toString(), 'Fogli A4'),
          rowLabelValue('Co2 evitata', proj.co2Saved.toString(), 'Kg'),
          rowLabelValue(
              'Co2 -> Petrolio',
              ValueConverter.fromCo2ToPetrolBarrels(proj.co2Saved).toString(),
              'Barili'),
          rowLabelValue('Elettricità corrispondente', '${watt.elem1} ',
              ' ${watt.elem2} KWh'),
        ],
      ),
    );
  }
}
