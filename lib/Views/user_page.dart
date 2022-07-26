import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/dataModel.dart';
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
            child:
                Consumer<DataManager>(builder: (context, dataManager, child) {
              if (!dataRequest) {
                dataManager.getUserData();
                dataRequest = true;
              }
              var data = dataManager.userData;

              if (data != null) {
                return UserPageListView(
                  user: data[UserData.info],
                  stats: data[UserData.stats],
                  badges: data[UserData.badge],
                );
              } else {
                return const CircularProgressIndicator(
                  color: mainColor,
                );
              }
            })));
  }
}

class UserPageListView extends StatelessWidget {
  final User user;
  final Statistics stats;
  final Map<Badge, bool> badges;

  const UserPageListView({
    Key? key,
    required this.user,
    required this.stats,
    required this.badges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Row(
          children: [
            UserInfoBanner(usr: user),
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

class UserInfoBanner extends StatelessWidget {
  final User usr;
  const UserInfoBanner({Key? key, required this.usr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: secondColor,
          borderRadius: BorderRadius.all(radiusCorner),
        ),
        child: Row(
          children: [
            //Profile image
            ClipOval(
              child: Image.asset(
                usr.userImageName ?? "$imagePath/userPlaceholder.jpeg",
                height: 90,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    "$imagePath/userPlaceholder.jpeg",
                    height: 90,
                  );
                },
              ),
            ),
            Flexible(
              //User info
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usr.getNameSurname(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            "Data Nascita: ${usr.dateBirth ?? "no data"}",
                            style: const TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: darkGray),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      usr.course ?? "no course info",
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: darkGray),
                    ),
                    Text(
                      "Immatricolato il: ${usr.registrationDate ?? 'no info'}",
                      style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: darkGray),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
