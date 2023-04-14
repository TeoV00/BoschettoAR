import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/utils.dart';

class UploadingDataView extends StatelessWidget {
  const UploadingDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return CenteredWidget(
      widgetToCenter: Column(
        children: [
          SizedBox(
            height: 80,
            child: SvgPicture.asset('$imagePath/forest.png'),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Invio dati sul totem",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text('Aggiornamento dati locali'),
          )
        ],
      ),
    );
  }
}
