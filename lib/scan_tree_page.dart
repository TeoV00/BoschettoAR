import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';

class ScanTreePage extends StatelessWidget {
  const ScanTreePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: pagePadding,
        child: Stack(children: [
          ARView(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: mainColor),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => {Navigator.pop(context)},
                ),
              )
            ],
          )
        ]),
      ),
    ));
  }
}

class ARView extends StatefulWidget {
  const ARView({Key? key}) : super(key: key);

  @override
  State<ARView> createState() => _ARViewState();
}

class _ARViewState extends State<ARView> {
  @override
  Widget build(BuildContext context) {
    return Text("data");
  }
}
