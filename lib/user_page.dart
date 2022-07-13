import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  //TODO: observer when datamodel change in order to update user info
  //in this state i keep percentage and all the value to show then when model change i update
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: pagePadding,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Row(
            children: const [
              UserInfoBanner(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              UserStatisticCounter(type: "Co2", amount: 011313, unit: "Kg"),
              TreeProgessBar(progress: 0.45), //TODO: here put the correct value
              UserStatisticCounter(type: "Carta", amount: 230, unit: "Fogli"),
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
          const BadgeContainer()
        ],
      ),
    ));
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
          'images/progressBarTree.png',
          alignment: Alignment.bottomCenter,
          height: treeHeight,
        ),
      ],
    );
  }
}

class BadgeContainer extends StatelessWidget {
  const BadgeContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: apply pattern mvc in order to update color of badges when unlocked achievements
    return GridView.count(
      shrinkWrap: true,
      crossAxisSpacing: 5,
      mainAxisSpacing: 4,
      padding: const EdgeInsets.all(20),
      crossAxisCount: 4,
      children: const <Widget>[
        BadgeCircle(badgeImage: "dsds", isActive: true),
        BadgeCircle(badgeImage: "dsds", isActive: true),
        BadgeCircle(badgeImage: "dsds", isActive: false),
        BadgeCircle(badgeImage: "dsds", isActive: true),
        BadgeCircle(badgeImage: "dsds", isActive: true),
        BadgeCircle(badgeImage: "dsds", isActive: false),
        BadgeCircle(badgeImage: "dsds", isActive: true),
        BadgeCircle(badgeImage: "dsds", isActive: true),
      ],
    );
  }
}

class BadgeCircle extends StatelessWidget {
  final String badgeImage;
  final bool isActive;

  const BadgeCircle(
      {Key? key, required this.badgeImage, required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? secondColor : disableBadge,
      ),
      child: Text(isActive.toString()), //TODO: put badge img
    );
  }
}

class UserInfoBanner extends StatefulWidget {
  const UserInfoBanner({Key? key}) : super(key: key);

  @override
  State<UserInfoBanner> createState() => _UserInfoBannerState();
}

class _UserInfoBannerState extends State<UserInfoBanner> {
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
            ClipOval(
              child: Image.asset(
                //TODO: load user image uri from domain
                "images/userPlaceholder.jpeg",
                height: 90,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Name and Surname",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    //TODO: Put user information from domain
                    Text("Anni: 22"),
                    Text("Unibo - Sede Cesena"),
                    Text("Immatricolato il: 2019-2020"),
                    Text("Corso: Ingnegneria e scienze informatiche",
                        overflow: TextOverflow.visible)
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
