import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/utils.dart';

class LoadingAppScreen extends StatelessWidget {
  const LoadingAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredWidget(
          widgetToCenter: Column(
        children: [
          SizedBox(
            width: 80,
            child: Image.asset('$imagePath/forest.png'),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              appName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const CircularProgressIndicator(
            color: mainColor,
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text('Aggiornamento dati locali'),
          )
        ],
      )),
    );
  }
}
