import 'package:flutter/material.dart';
import 'package:kanjanapisek_app/src/pages/homenew_page.dart';
import 'package:kanjanapisek_app/src/pages/mobileappnotisent_page.dart';
import 'package:kanjanapisek_app/src/pages/setting_page.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _mapGetLogin();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    HomeNew(),
    MobileAppNotiSentPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[_pages[_currentIndex]],
        ),
      ),
      bottomNavigationBar: Container(
        height: 110,
        child: BottomNavigationBar(
          //backgroundColor: Colors.transparent,
          backgroundColor: Colors.white,
          selectedFontSize: 18,
          unselectedFontSize: 14,
          selectedItemColor: Colors.red[900],
          unselectedItemColor: Colors.red[900],
          showUnselectedLabels: true,
          iconSize: 35,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() {
            _currentIndex = index;
          }),
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.red[900]),
              label: '',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications, color: Colors.red[900]),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.red[900]),
                label: ''),
          ],
        ),
      ),
    );
  }

  _mapGetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppVariables.IS_LOGIN = prefs.getBool(AppConstant.IS_LOGIN_PREF) ?? false;
    AppVariables.CUSTID = prefs.getString(AppConstant.CUSTID_PREF) ?? "-";
    AppVariables.CUSTNAME =
        prefs.getString(AppConstant.CUSTNAME_PREF) ?? "ลูกค้าทั่วไป";
    AppVariables.CUSTTEL = prefs.getString(AppConstant.CUSTTEL_PREF) ?? "-";

    print(AppVariables.CUSTNAME);
  }
}
