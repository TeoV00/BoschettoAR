import 'package:flutter/material.dart';
import 'package:tree_ar/Database/data_model.dart';
import 'package:tree_ar/Utils/unit_converter.dart';
import 'package:tree_ar/Views/infoPageView.dart/details_box_container.dart';
import 'package:tree_ar/utils.dart';

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
              'Barili di petrolio',
              ValueConverter.fromCo2ToPetrolBarrels(proj.co2Saved).toString(),
              'Barili'),
          rowLabelValue('Elettricità corrispondente', '${watt.elem1} ',
              ' ${watt.elem2} KWh'),
        ],
      ),
    );
  }
}
