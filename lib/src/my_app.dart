import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanjanapisek_app/src/models/customerconfig_response.dart';
import 'package:kanjanapisek_app/src/pages/home_page.dart';
import 'package:kanjanapisek_app/src/pages/start_page.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    _mapGetLogin();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Colors.transparent, // สีโปร่งใสสำหรับแถบนำทางด้านล่าง
      statusBarColor: Colors.transparent, // สีโปร่งใสสำหรับแถบสถานะด้านบน
    ));
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Kanit', // กำหนดฟอนต์หลักของแอปเป็น Kanit
      ),
      title: 'Kanjanapisek Gold',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: GetMobileAppSetting(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return HomePage();
            }
            return StartPage();
          }
          return StartPage();
        },
      ),
    );
  }

  Future<bool> GetMobileAppSetting() async {
    try {
      final responseServerDatabase =
          await http.get(Uri.parse('${AppConstant.URL_BSSCONFIGAPI}'));
      print("responseServerDatabase : ${AppConstant.URL_BSSCONFIGAPI}");

      if (responseServerDatabase.statusCode == 200) {
        final CustomerConfigResponse customerConfigResponse =
            CustomerConfigResponse.fromJson(
                json.decode(responseServerDatabase.body));
        print("fetchCustomer API " + customerConfigResponse.api!);
        print("fetchCustomer ServerIP " + customerConfigResponse.serverIp!);
        print("fetchCustomer DatabaseName " +
            customerConfigResponse.databaseName!);

        AppVariables.SERVERIP = customerConfigResponse.serverIp!;
        AppVariables.API = customerConfigResponse.api!;
        AppVariables.CustomerId = customerConfigResponse.databaseName!;
        AppVariables.ServerId = customerConfigResponse.serverIp!;

        return true;
      } else
        return false;
    } catch (_) {
      print("${_}");
      return false;
    }
  }
}
