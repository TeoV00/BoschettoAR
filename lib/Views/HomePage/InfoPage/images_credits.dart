import 'package:flutter/material.dart';
import 'package:tree_ar/Views/HomePage/InfoPage/info_page_const.dart';

class ImagesReferencesCopyright extends StatelessWidget {
  const ImagesReferencesCopyright({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            const Text("Riferimenti fonti immagini utilizzate:"),
            Column(
              children: [
                for (var i = 0; i < linkRef.length; i++) ...[Text(linkRef[i])]
              ],
            )
          ],
        ));
  }
}
