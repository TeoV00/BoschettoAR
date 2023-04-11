import 'package:flutter/material.dart';
import 'package:tree_ar/Views/ScanQr_views/scan_qr_view.dart';
import 'package:tree_ar/Views/Utils/round_back_button.dart';
import 'package:tree_ar/Views/ScanQr_views/ar_view_loader.dart';

import 'package:tree_ar/constant_vars.dart';

class ScanTreePage extends StatefulWidget {
  const ScanTreePage({Key? key}) : super(key: key);

  @override
  State<ScanTreePage> createState() => _ScanTreePageState();
}

class _ScanTreePageState extends State<ScanTreePage> {
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ScanQrView(afterScanChild: ArViewLoader()),
            const Padding(
              padding: pagePadding,
              child: RoundBackButton(result: null),
            )
          ],
        ),
      ),
    );
  }
}
