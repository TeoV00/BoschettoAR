import 'package:flutter/material.dart';
import 'package:tree_ar/Database/dataModel.dart';
import 'package:tree_ar/Views/User/user_info_banner.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/data_manager.dart';
import 'package:tree_ar/utils.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: pagePadding,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                children: const [UserInfoBanner()],
              ),
              StatisticsAndBadges(),
            ],
          ),
        ),
      ),
    );
  }
}

class StatisticsAndBadges extends StatefulWidget {
  StatisticsAndBadges({Key? key}) : super(key: key);
  final DataManager dataManager = DataManager();

  @override
  State<StatisticsAndBadges> createState() => _StatisticsAndBadgesState();
}

class _StatisticsAndBadgesState extends State<StatisticsAndBadges> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<UserData, dynamic>>(
      future: widget.dataManager.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data!;

          return UserDataViews(
            badges: data[UserData.badge],
            stats: data[UserData.stats],
          );
        } else if (snapshot.hasError) {
          return const CenteredWidget(
            widgetToCenter: Text("Errore caricamento dati"),
          );
        } else {
          return const CenteredWidget(
              widgetToCenter: CircularProgressIndicator(
            color: mainColor,
          ));
        }
      },
    );
  }
}

class UserDataViews extends StatelessWidget {
  final Statistics stats;
  final Map<Badge, bool> badges;

  const UserDataViews({
    Key? key,
    required this.stats,
    required this.badges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        const ImagesReferencesCopyright()
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
          height:
              treeHeight - 2, //sub 2 to remove green bar on right and bottom
          width: treeWidth - 2,
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
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      padding: const EdgeInsets.symmetric(vertical: 20),
      crossAxisCount: 5,
      children: <Widget>[
        for (var i = 0; i < badges.length; i++) ...[
          BadgeCircle(
              nameDescr: entries[i].key.descr,
              badgeImage: '$iconsPath/${entries[i].key.imageName}',
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
  const ImagesReferencesCopyright({Key? key}) : super(key: key);
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
