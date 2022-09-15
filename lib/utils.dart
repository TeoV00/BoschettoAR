import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';

class Pair<T, R> {
  late T elem1;
  late R elem2;

  Pair(T e1, R e2) {
    elem1 = e1;
    elem2 = e2;
  }

  @override
  String toString() {
    return '(${elem1.toString()}, ${elem2.toString()})';
  }
}

class Statistics {
  int papers;
  int co2;
  int totSavedCo2Proj;
  int totalHeight;
  int kiloWattHours;
  double progressPerc;

  Statistics(this.papers, this.co2, this.totalHeight, this.totSavedCo2Proj,
      this.kiloWattHours, this.progressPerc);
}

void showSnackBar(BuildContext context, Widget content, Duration? duration) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: content, duration: duration ?? const Duration(seconds: 4)),
  );
}

class CenteredWidget extends StatelessWidget {
  final Widget widgetToCenter;

  const CenteredWidget({Key? key, required this.widgetToCenter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [widgetToCenter],
        )
      ],
    );
  }
}

Widget getUserImageWidget(String? userImgPath) {
  return ClipOval(
    child: userImgPath != null && File(userImgPath).existsSync()
        ? Image.file(
            File(userImgPath),
            height: 90,
            width: 90,
          )
        : Image.asset(
            "$imagePath/userPlaceholder.jpeg",
            height: 90,
            width: 90,
          ),
  );
}

/// Get value in scientific annotation,
/// return a pair containing updated value and exponent
Pair<num, int?> getMultiplierString(num value) {
  int amountCifer = value.toInt().toString().length;

  if (amountCifer > 3 && amountCifer <= 6) {
    return Pair(value / 1000, 3);
  } else if (amountCifer > 6 && amountCifer <= 9) {
    return Pair(value / 1000000, 6);
  } else if (amountCifer > 9 && amountCifer <= 12) {
    return Pair(value / 1000000000, 9);
  } else {
    return Pair(value, null);
  }
}

Widget getExponentWidget(int exponent) {
  return RichText(
    text: TextSpan(children: [
      const TextSpan(text: 'x10', style: TextStyle(color: Colors.black)),
      WidgetSpan(
        child: Transform.translate(
          offset: const Offset(2, -4),
          child: Text(
            exponent.toString(),
            //superscript is usually smaller in size
            textScaleFactor: 1,
          ),
        ),
      )
    ]),
  );
}

const double textLabelDetailsSize = 15;

Widget rowIndicator(
  String label,
  TreeSpecs type,
  num value,
  num maxValue,
  double screenWidth,
) {
  const double iconSizeDefault = 24;
  int? multiplier = getMultiplierString(value.toInt()).elem2;

  String labelValue = "$label: ";

  maxValue = maxValue <= 0 ? value + 1 : maxValue;

  if (value > maxValue) {
    value = maxValue;
  }

  double textPixel = textLabelDetailsSize * (labelValue.length + 4);
  int maxIconCount = ((screenWidth - textPixel) / iconSizeDefault).ceil();
  int mappedVal = (maxIconCount * value) ~/ maxValue;

  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Text('$labelValue${getExponentWidget(multiplier ?? 0)}',
            style: const TextStyle(fontSize: textLabelDetailsSize)),
      ),
      // getIconIndicator(type, mappedVal),
    ],
  );
}

Widget getIconIndicator(TreeSpecs type, int value) {
  return Row(
    children: <Icon>[
      for (var i = 0; i < value; i++) ...[
        Icon(statsIcon[type]),
      ],
    ],
  );
}

Widget rowLabelValue(String label, dynamic value, String? unit) {
  int? exp;

  if (value is int || value is num || value is double) {
    var val_exp = getMultiplierString(value);
    // log("$value --> ${val_exp.elem1} ${val_exp.elem2}");
    exp = val_exp.elem2;
    value = val_exp.elem1;
  }

  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Text('$label:',
            style: const TextStyle(fontSize: textLabelDetailsSize)),
      ),
      Text(value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      Padding(
        padding: const EdgeInsets.only(left: 5),
        child: exp != null ? getExponentWidget(exp) : const Text(''),
      ),
      const Spacer(),
      Text(unit ?? '', style: const TextStyle(fontSize: 16)),
    ],
  );
}
