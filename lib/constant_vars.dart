import 'package:flutter/material.dart';

const mainColor = Color(0xFF96BB7C);
const secondColor = Color(0xFFD6EFC7);
const grayColor = Color.fromARGB(250, 235, 235, 235);
const disableBadge = Colors.grey;
const topSectionTabWidth = 250.0;
const pagePadding = EdgeInsets.only(top: 10, left: 10, right: 10);
const double grassBottomBarHeight = 40;
const double selectedFontSizeBottomNav = 15;
const radiusCorner = Radius.circular(15);

const textStyleUserInfo = TextStyle(
    // fontWeight: FontWeight.bold,
    fontSize: 15,
    color: Color.fromARGB(255, 67, 67, 67));

enum InfoType { tree, project }

enum StatsType {
  co2(0),
  paper(1),
  leafs(2);

  const StatsType(this.value);
  final int value;
}

const statsIcon = [
  Icons.local_gas_station, //StatsType.co2
  Icons.description, //StatsType.paper
  Icons.eco //StatsType.leafs
];
