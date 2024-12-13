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
      body: Stack(
        children: [
          // PageView ที่แสดงหน้าต่างๆ
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: _pages,
          ),
          // Custom Bottom Bar
          Positioned(
            bottom: 20, // ระยะห่างจากขอบล่างของหน้าจอ
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ปุ่ม Home
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                      _pageController.jumpToPage(0);
                    });
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor:
                        _currentIndex == 0 ? Colors.red[900] : Colors.white,
                    child: Icon(
                      Icons.home,
                      color:
                          _currentIndex == 0 ? Colors.white : Colors.red[900],
                      size: 35,
                    ),
                  ),
                ),
                // ปุ่ม Notifications
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                      _pageController.jumpToPage(1);
                    });
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor:
                        _currentIndex == 1 ? Colors.red[900] : Colors.white,
                    child: Icon(
                      Icons.notifications,
                      color:
                          _currentIndex == 1 ? Colors.white : Colors.red[900],
                      size: 35,
                    ),
                  ),
                ),
                // ปุ่ม Profile
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                      _pageController.jumpToPage(2);
                    });
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor:
                        _currentIndex == 2 ? Colors.red[900] : Colors.white,
                    child: Icon(
                      Icons.person,
                      color:
                          _currentIndex == 2 ? Colors.white : Colors.red[900],
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
