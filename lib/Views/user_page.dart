import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/dataModel.dart';
import 'package:tree_ar/Database/database_constant.dart';
import 'package:tree_ar/Views/User/user_info_banner.dart';
import 'package:tree_ar/Views/edit_user_page.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/data_manager.dart';

import '../UtilsModel.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool dataRequest = false;
    return SafeArea(
      child: Padding(
        padding: pagePadding,
        child: Consumer<DataManager>(
          builder: (context, dataManager, child) {
            if (!dataRequest) {
              dataManager.getUserData();
              dataRequest = true;
            }
            var data = dataManager.userData;

            if (data != null) {
              return UserPageListView(
                stats: data[UserData.stats],
                badges: data[UserData.badge],
              );
            } else {
              return const CircularProgressIndicator(
                color: mainColor,
              );
            }
          },
        ),
      ),
    );
  }
}

class UserPageListView extends StatelessWidget {
  final Statistics stats;
  final Map<Badge, bool> badges;

  const UserPageListView({
    Key? key,
    required this.stats,
    required this.badges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Row(
          children: const [
            UserInfoBanner(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            UserStatisticCounter(type: "Co2", amount: stats.co2, unit: "Kg"),
            TreeProgessBar(progress: stats.progress),
            UserStatisticCounter(
                type: "Carta", amount: stats.papers, unit: "Fogli"),
          ],
        ),
        Row(
          children: const [
            Text("Altre informazioni e statistiche su alberi e rpogetti")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              "Badge Ottenuti",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
        BadgeContainer(badges: badges),
        ImagesReferencesCopyright()
      ],
    );
  }
}

class UserStatisticCounter extends StatelessWidget {
  final String type;
  final int amount;
  final String unit;

  const UserStatisticCounter(
      {Key? key, required this.type, required this.amount, required this.unit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          type,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            amount.toString(),
            style: const TextStyle(fontSize: 22),
          ),
        ),
        Text(
          unit,
          style: const TextStyle(fontSize: 16),
        )
      ],
    );
  }
}

class TreeProgessBar extends StatefulWidget {
  final double progress;
  const TreeProgessBar({Key? key, required this.progress}) : super(key: key);

  @override
  State<TreeProgessBar> createState() => _TreeProgressBar();
}

class _TreeProgressBar extends State<TreeProgessBar> {
  final double treeHeight = 130;
  final double treeWidth = 120;

  @override
  Widget build(BuildContext context) {
    final double percValue = (widget.progress / 100) * treeHeight;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          height: treeHeight,
          width: treeWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [mainColor, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [percValue, percValue],
            ),
          ),
        ),
        Text("${widget.progress * 100} %",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        Image.asset(
          '$imagePath/progressBarTree.png',
          alignment: Alignment.bottomCenter,
          height: treeHeight,
        ),
      ],
    );
  }
}

class BadgeContainer extends StatelessWidget {
  const BadgeContainer({Key? key, required this.badges}) : super(key: key);
  final Map<Badge, bool> badges;

  @override
  Widget build(BuildContext context) {
    var entries = badges.entries.toList();
    return GridView.count(
      shrinkWrap: true,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      padding: const EdgeInsets.symmetric(vertical: 20),
      crossAxisCount: 5,
      children: <Widget>[
        for (var i = 0; i < badges.length; i++) ...[
          BadgeCircle(
              nameDescr: entries[i].key.descr,
              badgeImage: '$iconsPath/badge${entries[i].key.id}.png',
              isActive: entries[i].value),
        ]
      ],
    );
  }
}

class BadgeCircle extends StatelessWidget {
  final String badgeImage;
  final String nameDescr;
  final bool isActive;

  const BadgeCircle(
      {Key? key,
      required this.nameDescr,
      required this.badgeImage,
      required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      message: nameDescr,
      child: ClipOval(
          child: ColorFiltered(
        colorFilter: ColorFilter.mode(
            isActive ? badgeColor : disableBadge, BlendMode.color),
        child: Image.asset(
          badgeImage,
          centerSlice: Rect.largest,
        ),
      )),
    );
  }
}

class ImagesReferencesCopyright extends StatelessWidget {
  final linkRef = [
    "it.freepik.com - Icone dei Badge",
    "www.onlinewebfonts.com - Progress bar"
  ];

  ImagesReferencesCopyright({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 100, bottom: 40),
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
