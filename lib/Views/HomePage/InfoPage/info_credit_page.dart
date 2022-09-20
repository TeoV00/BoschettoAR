import 'package:flutter/material.dart';
import 'package:tree_ar/Views/HomePage/InfoPage/images_credits.dart';
import 'package:tree_ar/Views/HomePage/InfoPage/info_page_const.dart';
import 'package:tree_ar/Views/DetailsPageView/details_box_container.dart';
import 'package:tree_ar/constant_vars.dart';

const String descrCarboonOfPaper = '''
''';

class InfoCreditsPage extends StatelessWidget {
  const InfoCreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> sections = [
      Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 100,
          child: Image.asset("$imagePath/forest1.png"),
        ),
      )
    ];

    for (var elem in infoSections) {
      sections.add(
        padding10All(
          DetailsBox(
            headerTitle: elem['title']!,
            childBox: Text(elem['body']!),
          ),
        ),
      );
    }
    sections.add(
      padding10All(const ImagesReferencesCopyright()),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informazioni'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: sections,
        ),
      ),
    );
  }
}

Widget padding10All(Widget child) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
    child: child,
  );
}
