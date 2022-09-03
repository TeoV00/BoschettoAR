import 'package:flutter/material.dart';

const List<String> tutorialText = [
  'Tocca sul prato e verranno mostrati i plici di carta risparmiati dalla università',
  'Tocca una seconda volta e verrano posizionati i barili di petrolio corrispondenti!',
  'Suggerimento! Spostati e tocca in un altro punto distante dai plichi di carta, per vedere meglio!'
];

const TextStyle textStyle = TextStyle(fontSize: 16);

class HintBanner extends StatefulWidget {
  const HintBanner({super.key});
  @override
  State<HintBanner> createState() => _HintBannerState();
}

class _HintBannerState extends State<HintBanner> {
  int currentHint = 0;
  bool isPrevButtonDisabled = true;
  bool isNextButtonDisabled = false;

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
                    child: Text(tutorialText[currentHint], style: textStyle),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed:
                      isPrevButtonDisabled ? null : () => _prevTutorialHint(),
                  child: const Text('Precedente'),
                ),
                TextButton(
                  onPressed:
                      isNextButtonDisabled ? null : () => _nextTutorialHint(),
                  child: const Text('Prossimo'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _nextTutorialHint() {
    setState(() {
      isPrevButtonDisabled = false;
      if (currentHint < tutorialText.length - 1) {
        currentHint++;
        if (currentHint == tutorialText.length - 1) {
          isNextButtonDisabled = true;
        }
      }
    });
  }

  void _prevTutorialHint() {
    setState(() {
      if (currentHint > 0) {
        currentHint--;
        isNextButtonDisabled = false;
        if (currentHint == 0) {
          isPrevButtonDisabled = true;
        }
      } else if (currentHint == 0) {
        isPrevButtonDisabled = true;
      }
    });
  }
}
