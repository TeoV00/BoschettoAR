import 'package:flutter/material.dart';
import 'package:tree_ar/Database/data_model.dart';
import 'package:tree_ar/Views/Utils/unit_converter.dart';
import 'package:tree_ar/Views/DetailsPageView/details_box_container.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/utils.dart';

class ProjectDetailsBox extends StatelessWidget {
  final Project proj;
  const ProjectDetailsBox({Key? key, required this.proj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var watt = ValueConverter.fromCo2ToKiloWatt(proj.co2Saved).toInt();

    return Column(
      children: [
        DetailsBox(
          headerTitle: 'Dettagli',
          childBox: Column(
            children: [
              rowLabelValue('Categoria', proj.category.toString(), null),
              rowLabelValue('Anni di Dematerializzazione', proj.years, null),
              rowLabelValue('Alberi piantati', proj.treesCount, null),
            ],
          ),
        ),
        DetailsBox(
            headerTitle: 'Dati sui risparmi',
            childBox: Column(
              children: [
                rowLabelValue('Carta risparmiata', proj.paper, 'Fogli A4'),
                rowLabelValue('$co2String evitata', proj.co2Saved, 'Kg'),
                rowLabelValue(
                    'Litri di Benzina',
                    ValueConverter.fromCo2ToBenzinaLiter(proj.co2Saved),
                    'Litri'),
                rowLabelValue(
                    'Taniche da 20 litri di benzina',
                    ValueConverter.fromCo2ToFuelTanks(proj.co2Saved),
                    'Taniche'),
                rowLabelValue('Elettricità corrispondente', watt, 'KWh'),
              ],
            ))
      ],
    );
  }
}
