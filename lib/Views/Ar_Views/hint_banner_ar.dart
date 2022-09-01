import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/utils/utils.dart';

const List<String> tutorialText = [
  'Tocca sul prato e verranno mostrati i plici di carta risparmiati dalla università',
  'Tocca una seconda volta e verrano posizionati i barili di petrolio corrispondenti!',
  'Suggerimento! Spostati e tocca in un altro punto distante dai plichi di carta, per vedere meglio!'
];

class HintBanner extends StatefulWidget {
  const HintBanner({super.key});
  @override
  State<HintBanner> createState() => _HintBannerState();
}

class _HintBannerState extends State<HintBanner> {
  int currentHint = 0;
  bool hideBanner = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 100, top: 50, right: 5),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      tutorialText[currentHint],
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => prevTutorialHint(),
                  child: const Text('Precedente'),
                ),
                TextButton(
                  onPressed: () => nextTutorialHint(),
                  child: Text(hideBanner ? 'Fine' : 'Prossimo'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void nextTutorialHint() {
    setState(() {
      if (currentHint < tutorialText.length - 1) {
        currentHint++;
        if (currentHint == tutorialText.length - 1) {
          hideBanner = true;
        }
      } else if (hideBanner) {
        log("Close tutorial banner");
      }
    });
  }

  void prevTutorialHint() {
    setState(() {
      if (currentHint > 0) {
        currentHint--;
        hideBanner = false;
      }
    });
  }
}
