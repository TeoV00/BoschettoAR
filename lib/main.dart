import 'dart:async';
import 'package:tree_ar/utils.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tree_ar/DataProvider/data_manager.dart';
import 'Views/user_page.dart';
import 'constant_vars.dart';
import 'Views/home_page.dart';
import 'Views/ScanQr_views/scan_qr_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DataManager dataManager = DataManager();

  runApp(
    ChangeNotifierProvider(
      create: (context) => dataManager,
      child: MyApp(
        dataManager: dataManager,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final DataManager dataManager;
  const MyApp({Key? key, required this.dataManager}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = true;
    bool timeExpired = false;

    return MaterialApp(
      title: 'Unibo Tree AR',
      theme: ThemeData(
        primaryColor: mainColor,
      ),
      //loading app interface, quite like a splash screen
      home: FutureBuilder<void>(
          future: widget.dataManager
              .fetchOnlineData()
              .timeout(
                const Duration(seconds: 5),
                onTimeout: () => {isLoading = false, timeExpired = true},
              )
              .then(
                (value) => isLoading = false,
              ),
          builder: (context, snapshot) {
            if (!isLoading) {
              return TabView(timeExpired: timeExpired);
            } else if (isLoading == true) {
              return const LoadingAppScreen();
            } else {
              throw Exception();
              // return const Text('Caso non gestito ');
            }
          }),
    );
  }
}

class LoadingAppScreen extends StatelessWidget {
  const LoadingAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredWidget(
          widgetToCenter: Column(
        children: const [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Boschetto Cesena - Unibo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          CircularProgressIndicator(
            color: mainColor,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('Aggiornamento dati locali'),
          )
        ],
      )),
    );
  }
}

class TabView extends StatefulWidget {
  final bool timeExpired;
  const TabView({Key? key, required this.timeExpired}) : super(key: key);

  @override
  State<TabView> createState() => _TabViewState();
}

/// State of TabView widget, manages gui and logic of bottom nav bar
/// when tap on button it change selected view and show it
class _TabViewState extends State<TabView> with AfterLayoutMixin<TabView> {
//selected page index
  int _selectionIndex = 0; //deafultpage
  //Children screen of app
  late List<Widget> _appScreenPages;

  @override
  void initState() {
    super.initState();
    _appScreenPages = <Widget>[
      const MainPage(),
      const UserPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
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
          Flex(
            direction: Axis.vertical,
            children: [
              Expanded(child: _appScreenPages[_selectionIndex]),
            ],
          ),
          LayoutBuilder(builder: ((context, constraints) {
            var parentWidth = constraints.maxWidth;
            return SizedBox(
              width: parentWidth,
              height: grassBottomBarHeight,
              child: SvgPicture.asset(
                '$imagePath/grass.svg',
                color: mainColor,
                excludeFromSemantics: true,
                fit: BoxFit.fill,
              ),
            );
          }))
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: selectedFontSizeBottomNav,
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
            MaterialPageRoute(
              builder: (context) => const ScanTreePage(),
            ),
          ),
        },
        child: const ImageIcon(
          AssetImage('$iconsPath/ScanTreeIcon.png'),
          color: Colors.black,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    if (widget.timeExpired) {
      showSnackBar(
          context,
          const Text(
              "Non è stato possibile aggironare i dati locali, controllare connessione ad internet"),
          const Duration(seconds: 5));
    }
  }
}
