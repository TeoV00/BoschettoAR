import 'package:flutter/material.dart';

const mainColor = Color(0xFF96BB7C);
const secondColor = Color(0xFFD6EFC7);
const badgeColor = Color.fromARGB(255, 216, 238, 215);
const grayColor = Color.fromARGB(255, 235, 235, 235);
const disableBadge = Colors.grey;
const darkGray = Color.fromARGB(255, 53, 53, 53);
const topSectionTabWidth = 250.0;
const pagePadding = EdgeInsets.only(top: 10, left: 10, right: 10);
const double grassBottomBarHeight = 40;
const double selectedFontSizeBottomNav = 15;
const radiusCorner = Radius.circular(15);

const iconsPath = "assets/icons";
const imagePath = "assets/images";
const defualtUserImageName = "userPlaceholder.jpeg";

enum InfoType { tree, project }

enum StatsType {
  co2(0),
  paper(1),
  leafs(2);

  const StatsType(this.value);
  final int value;
}

enum UserData { info, stats, badge }

const statsIcon = [
  Icons.local_gas_station, //StatsType.co2
  Icons.description, //StatsType.paper
  Icons.eco //StatsType.leafs
];

// Edit user info Form style
const labelStyle = TextStyle(
  color: Color.fromARGB(255, 46, 128, 49),
  fontSize: 20,
);

// References for all images  with copyright free to be used showing author
final linkRef = [
  "it.freepik.com - Icone dei Badge",
  "www.onlinewebfonts.com - Progress bar"
];
