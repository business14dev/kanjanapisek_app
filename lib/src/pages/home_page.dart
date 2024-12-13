import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanjanapisek_app/src/pages/homenew_page.dart';
import 'package:kanjanapisek_app/src/pages/pawnmt_page.dart';
// import 'package:maeprasert_app/src/pages/goldbar_page.dart';
// import 'package:maeprasert_app/src/pages/pawn_page.dart';
import 'package:kanjanapisek_app/src/pages/savingmt_page.dart';
import 'package:kanjanapisek_app/src/pages/setting_page.dart';
// import 'package:maeprasert_app/src/pages/timeline_page.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    HomeNew(),
    SavingmtPage(),
    // PawnmtPage(),
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
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Color(0xFF7a131a),
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('หน้าหลัก'),
              icon: Icon(Icons.home),
              inactiveColor: Color(0xFFfefca7),
              activeColor:  Color(0xFFfefca7)),
          BottomNavyBarItem(
              title: Text('ออมทอง'),
              icon: Icon(Icons.savings),
              inactiveColor:  Color(0xFFfefca7),
              activeColor:  Color(0xFFfefca7)),
          // BottomNavyBarItem(
          //     title: Text('ขายฝาก'),
          //     icon: Icon(Icons.account_balance),
          //     inactiveColor: AppConstant.PRIMARY_COLOR,
          //     activeColor: AppConstant.PRIMARY_COLOR),
          BottomNavyBarItem(
              title: Text('ติดต่อเรา'),
              icon: Icon(Icons.menu),
              inactiveColor:  Color(0xFFfefca7),
              activeColor:  Color(0xFFfefca7)),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
