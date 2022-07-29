import 'package:flutter/material.dart';
import 'package:tree_ar/Database/dataModel.dart';
import 'package:tree_ar/Views/User/badge_view.dart';
import 'package:tree_ar/Views/User/user_progress_banner.dart';
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
              const ImagesReferencesCopyright(),
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
        const Divider(
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserStatisticCounter(
                type: "Altezza", amount: stats.co2, unit: "cm"),
            UserStatisticCounter(
                type: "Acqua", amount: stats.co2, unit: "litri"),
            UserStatisticCounter(
                type: "Anni medi", amount: stats.co2, unit: "anni"),
            UserStatisticCounter(
                type: "Petrolio", amount: stats.co2, unit: "barili"),
          ],
        ),
        const Divider(
          thickness: 1,
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
      ],
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
