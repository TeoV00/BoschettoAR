// import 'package:webview_flutter/webview_flutter.dart';

import 'package:tree_ar/constant_vars.dart';
import 'package:flutter/material.dart';

class ScanTreePage extends StatelessWidget {
  const ScanTreePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        const ARWebView(),
        Padding(
          padding: pagePadding,
          child: Row(
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
          ),
        )
      ]),
    ));
  }
}

class ARWebView extends StatefulWidget {
  const ARWebView({Key? key}) : super(key: key);

  @override
  State<ARWebView> createState() => _StateARWebView();
}

class _StateARWebView extends State<ARWebView> {
  @override
  Widget build(BuildContext context) {
    return Text("data");
  }
}
