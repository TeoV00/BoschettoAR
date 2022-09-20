import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/data_model.dart';
import 'package:tree_ar/Views/Utils/unit_converter.dart';
import 'package:tree_ar/Views/User/badge_view.dart';
import 'package:tree_ar/Views/User/stats_counter.dart';
import 'package:tree_ar/Views/User/user_progress_banner.dart';
import 'package:tree_ar/Views/User/user_info_banner.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/DataProvider/data_manager.dart';
import 'package:tree_ar/utils.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        title: const Text("Profilo"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: grassPaddingHeight),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: const [UserInfoBanner()],
                ),
                const StatisticsAndBadges(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatisticsAndBadges extends StatefulWidget {
  const StatisticsAndBadges({Key? key}) : super(key: key);

  @override
  State<StatisticsAndBadges> createState() => _StatisticsAndBadgesState();
}

class _StatisticsAndBadgesState extends State<StatisticsAndBadges> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataManager>(builder: (context, dataManager, child) {
      return FutureBuilder<Map<UserData, dynamic>>(
        future: dataManager.getUserData(),
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
    });
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            UserStatisticCounter(
                type: "$co2String Evitata",
                amount: stats.totSavedCo2Proj,
                unit: "Kg"),
            TreeProgessBar(progressPerc: stats.progressPerc),
            UserStatisticCounter(
                type: "Carta", amount: stats.papers, unit: "Fogli A4"),
          ],
        ),
        const Divider(
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            UserStatisticCounter(
                type: "Elettricità",
                amount: ValueConverter.fromCo2ToKiloWatt(stats.totSavedCo2Proj)
                    .toInt(),
                unit: "KWh"),
            UserStatisticCounter(
                type: "Benzina",
                amount:
                    ValueConverter.fromCo2ToBenzinaLiter(stats.totSavedCo2Proj)
                        .toInt(),
                unit: "Litri"),
            UserStatisticCounter(
                type: "$co2String\nAlberi", amount: stats.co2, unit: "Kg/Anno"),
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
