import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const mainColor = Color(0xFF96BB7C);

enum infoType { TREE, PROJECT }

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
      home: const HomePage(),
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
  int _selectionIndex = 0;

  //Children screen of app
  static const List<Widget> _appScreenPages = <Widget>[
    MainPage(), //TODO: here put homepage widget
    Text("profile") // TODO: here put profile widget
  ];

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
        backgroundColor: Color(0xFFD6EFC7),
        child: const ImageIcon(
          AssetImage("ScanTreeIcon.png"),
          color: Colors.black,
          size: 32,
        ),
        onPressed: _openAr,
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
  infoType _selectedType = infoType.TREE;

  void _onTapTab(infoType typeSelected) {
    setState(() {
      _selectedType = typeSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFD6EFC7)),
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Porgetti"), Text("Alberi")],
            ),
          ),
          const Text("Ciaoooo"),
          //ListView(), list all project or tree
        ],
      ),
    );
  }
}
