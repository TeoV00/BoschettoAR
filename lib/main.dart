import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'constant_vars.dart';
import 'home_page.dart';
import 'user_page.dart';
import 'scan_tree_page.dart';

void main() {
  runApp(const MyApp());
}

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
      home: const SafeArea(
        child: TabView(),
      ),
    );
  }
}

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  State<TabView> createState() => _TabViewState();
}

/// State of TabView widget, manages gui and logic of bottom nav bar
/// when tap on button it change selected view and show it
class _TabViewState extends State<TabView> {
//selected page index
  int _selectionIndex = 0; //deafultpage

  //Children screen of app
  static const List<Widget> _appScreenPages = <Widget>[MainPage(), UserPage()];

  void _onItemTapped(int index) {
    setState(() {
      //That method inform that has changed state of gui
      _selectionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _appScreenPages[_selectionIndex],
          LayoutBuilder(builder: ((context, constraints) {
            var parentWidth = constraints.maxWidth;
            return SizedBox(
              width: parentWidth,
              height: grassBottomBarHeight,
              child: SvgPicture.asset(
                'images/grass.svg',
                color: mainColor,
                excludeFromSemantics: true,
                fit: BoxFit.fill,
              ),
            );
          }))
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: selectedFontSize_bottomNav,
        elevation: 0, //To remove shadow between grass image and bottomBar
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
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScanTreePage()),
          )
        },
        child: const ImageIcon(
          AssetImage('icons/ScanTreeIcon.png'),
          color: Colors.black,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
    );
  }
}
