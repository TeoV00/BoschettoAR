import 'package:flutter/material.dart';

//url to fetch project info
const urlProjectInfo = '';

const mainColor = Color(0xFF96BB7C);
const secondColor = Color(0xFFD6EFC7);
const badgeColor = Color.fromARGB(255, 216, 238, 215);
const grayColor = Color.fromARGB(255, 235, 235, 235);
const disableBadge = Colors.grey;
const darkGray = Color.fromARGB(255, 53, 53, 53);
const topSectionTabWidth = 250.0;
const pagePadding = EdgeInsets.only(top: 10, left: 10, right: 10);
const double grassHeight = 40;
const double grassPaddingHeight = 20;

const double selectedFontSizeBottomNav = 15;
const radiusCorner = Radius.circular(15);

const double imageSizeDetailPage = 200;

const iconsPath = "assets/icons";
const imagePath = "assets/images";
const defualtUserImageName = "userPlaceholder.jpeg";

enum InfoType { tree, project, other }

enum UserData { info, stats, badge }

enum TreeSpecs {
  co2,
  paper,
  totalPaper,
  height,
  diameter,
  maxTemp,
  minTemp,
  water;
}

Map<TreeSpecs, IconData> statsIcon = {
  TreeSpecs.paper: Icons.description,
  TreeSpecs.co2: Icons.local_gas_station,
  TreeSpecs.height: Icons.straighten,
  TreeSpecs.water: Icons.water_drop,
  TreeSpecs.diameter: Icons.circle
};

// Edit user info Form style
const labelStyle = TextStyle(
  color: Color.fromARGB(255, 46, 128, 49),
  fontSize: 20,
);
