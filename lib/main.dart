// ignore_for_file: unnecessary_this
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const mainColor = Color(0xFF96BB7C);
const secondColor = Color(0xFFD6EFC7);
const grayColor = Color.fromARGB(250, 235, 235, 235);
const topSectionTabWidth = 250.0;

enum InfoType { TREE, PROJECT }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unibo Tree AR',
      theme: ThemeData(
        primaryColor: mainColor,
      ),
      home: const SafeArea(child: HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//selected page index
  int _selectionIndex = 1; //deafultpage

  //Children screen of app
  static const List<Widget> _appScreenPages = <Widget>[MainPage(), UserPage()];

  void _onItemTapped(int index) {
    setState(() {
      //That method inform that has changed state of gui
      _selectionIndex = index;
    });
  }

  void _openAr() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _appScreenPages[_selectionIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, size: 30),
              label: 'Profilo')
        ],
        currentIndex: _selectionIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        backgroundColor: mainColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondColor,
        onPressed: _openAr,
        child: const ImageIcon(
          AssetImage('icons/ScanTreeIcon.png'),
          color: Colors.black,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  InfoType _selectedType = InfoType.TREE;

  void _onTapTab(InfoType typeSelected) {
    setState(() {
      _selectedType = typeSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    const tabButtonWidth = (topSectionTabWidth / 2) - 45;
    return Scaffold(
      body: Stack(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(child: CustomListView(dataType: _selectedType)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: secondColor),
                height: 50,
                width: topSectionTabWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ChoiceChip(
                      label: const SizedBox(
                        width: tabButtonWidth,
                        child: Text(
                          "Alberi",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      selected: _selectedType == InfoType.TREE,
                      onSelected: (_) => _onTapTab(InfoType.TREE),
                      selectedColor: Colors.white,
                    ),
                    ChoiceChip(
                      label: const SizedBox(
                        width: tabButtonWidth,
                        child: Text(
                          "Progetti",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      selected: _selectedType == InfoType.PROJECT,
                      onSelected: (_) => _onTapTab(InfoType.PROJECT),
                      selectedColor: Colors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomListView extends StatefulWidget {
  final InfoType dataType;
  const CustomListView({Key? key, required this.dataType}) : super(key: key);

  @override
  _CustomListView createState() => _CustomListView();
}

class _CustomListView extends State<CustomListView> {
  @override
  Widget build(BuildContext context) {
    //get data to show in list of category InfoType
    final List<String> entries = DataManager.getDataOf(widget.dataType);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(top: 60, left: 8, right: 8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return RowItem(itemId: entries[index], type: widget.dataType);
        });
  }
}

class RowItem extends StatelessWidget {
  final String itemId;
  final InfoType type;

  static const margin5H = EdgeInsets.symmetric(horizontal: 5);

  const RowItem({Key? key, required this.itemId, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 85,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: grayColor,
      ),
      child: Row(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 19),
              height: 57,
              width: 57,
              //TODO: remove black square and put an image of tree or project logo
              color: Colors.black,
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: margin5H,
              child: Text(
                "$itemId - Place Name", //TODO: get name by id and type
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            Padding(
              padding: margin5H,
              child: Text(
                type.name, //TODO: get details-description by id and type
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class DataManager {
  ///static function to get trees or Projects items scanned byt user to be showed
  ///in listview.
  static List<String> getDataOf(InfoType dataType) {
    if (dataType == InfoType.PROJECT) {
      return <String>['G', 'e', 'f', 'd', 'e', 'f', 'd'];
    } else {
      return <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'];
    }
  }
}

/* -------------PROFILE PAGE--------------- */

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPage createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  //TODO: observer when datamodel change in order to update user info
  //in this state i keep percentage and all the value to show then when model change i update
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 5, right: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              UserStatisticCounter(type: "Co2", amount: 011313, unit: "Kg"),
              TreeProgessBar(progress: 0.5),
              UserStatisticCounter(type: "Carta", amount: 230, unit: "Fogli"),
            ],
          ),
          const Text("Badges unlocked")
        ],
      ),
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
        Text("${widget.progress} %",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        Image.asset(
          'images/progressBarTree.png',
          alignment: Alignment.bottomCenter,
          height: this.treeHeight,
        ),
      ],
    );
  }
}
