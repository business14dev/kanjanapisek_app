import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:kanjanapisek_app/src/pages/contact_page.dart';
import 'package:kanjanapisek_app/src/pages/home_page.dart';
import 'package:kanjanapisek_app/src/pages/loginscreen_page.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String version = "";

  @override
  void initState() {
    super.initState();
    print('initState called');
    _getAppVersion(); // เรียกฟังก์ชันดึงเวอร์ชันตอนเริ่มต้น
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print("App Version: ${packageInfo.version}");
    print("Build Number: ${packageInfo.buildNumber}");
    setState(() {
      version = packageInfo.version; // บันทึกเวอร์ชันในตัวแปร
    });
  }

  Future<void> openNotificationSettings() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.APP_NOTIFICATION_SETTINGS',
        arguments: {
          'android.provider.extra.APP_PACKAGE':
              'com.maeprasertcgold.maeprasertgoldapp', // เปลี่ยนเป็น package name ของแอปคุณ
        },
      );
      await intent.launch();
    } else if (Platform.isIOS) {
      // สำหรับ iOS คุณสามารถเปิดหน้า settings หลักได้ แต่ไม่สามารถเปิดหน้าการแจ้งเตือนโดยตรง
      final Uri url = Uri.parse('app-settings:');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg-setting3.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
            ),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 30, left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLogo(),
                    ..._buildComName(),
                    SizedBox(height: 10),
                    _buildSetting(),
                    ..._buildLogInOut(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildSetting() {
    return Column(
      children: [
        Divider(),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('การแจ้งเตือน', style: TextStyle(fontSize: 20), textScaler: TextScaler.linear(1)),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            openNotificationSettings();
          },
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('ติดต่อเรา สาขา', style: TextStyle(fontSize: 20), textScaler: TextScaler.linear(1)),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // _makePhoneCall('043711056');
            Navigator.push(context, MaterialPageRoute(builder: ((context) => ContactPage())));
        
          },
        ),
        // ListTile(
        //   leading: Icon(Icons.phone),
        //   title: Text('ติดต่อเรา สาขา 2', style: TextStyle(fontSize: 20), textScaler: TextScaler.linear(1)),
        //   trailing: Icon(Icons.arrow_forward_ios),
        //   onTap: () {
        //     _makePhoneCall('043711117');
        //   },
        // ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('นโยบายความเป็นส่วนตัว', style: TextStyle(fontSize: 20), textScaler: TextScaler.linear(1)),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            _launchUrlPolicy();
          },
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('ข้อตกลงและเงื่อนไข', style: TextStyle(fontSize: 20), textScaler: TextScaler.linear(1)),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            _launchUrlTerm();
          },
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('เวอร์ชัน', style: TextStyle(fontSize: 20), textScaler: TextScaler.linear(1)),
          trailing: Text(version, style: TextStyle(fontSize: 20), textScaler: TextScaler.linear(1)),
        ),
        Divider(),
      ],
    );
  }

  Container _buildLogo() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20.0),
            width: 130,
            height: 130,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/logo.png")),
                border: Border.all(color: Color(0xFFe4cc74), width: 2.0, style: BorderStyle.solid)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildComName() {
    return <Widget>[
      Text(
        "ห้างทองกาญจนาภิเษก ขอนแก่น",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          //color: Colors.blueGrey[600],
          color: AppConstant.PRIMARY_COLOR,
        ),
         textScaler: TextScaler.linear(1)
      ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        "  สาขา หน้าเมือง1 - ข้างตลาดสดบางลำภู",
        style: TextStyle(
          fontSize: 18,
          color: AppConstant.PRIMARY_COLOR,
        ),
         textScaler: TextScaler.linear(1)
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        "  สาขา หน้าเมือง2 - เยื้องแฟรี่พลาซ่า",
        style: TextStyle(
          fontSize: 18,
          color: AppConstant.PRIMARY_COLOR,
        ),
         textScaler: TextScaler.linear(1)
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        "  สาขา หนองเรือ",
        style: TextStyle(
          fontSize: 18,
          color: AppConstant.PRIMARY_COLOR,
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        "  สาขา ดอนโมง",
        style: TextStyle(
          fontSize: 18,
          color: AppConstant.PRIMARY_COLOR,
        ),
         textScaler: TextScaler.linear(1)
      ),
       SizedBox(
        height: 5,
      ),
      Text(
        "  เวลาเปิด - ปิด 08.00 - 17.00 น. หยุดทุกวันอาทิตย์",
        style: TextStyle(
          fontSize: 16,
          color: Colors.red,
        ),
         textScaler: TextScaler.linear(1)
      ),
      SizedBox(
        height: 10,
      ),
    ];
  }

  List<Widget> _buildLogInOut(BuildContext context) {
    if (AppVariables.CUSTID == "-") {
      return <Widget>[
        Text(
          AppVariables.CUSTNAME,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppConstant.PRIMARY_COLOR,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          AppVariables.CUSTID,
          style: TextStyle(
            fontSize: 14,
            color: AppConstant.PRIMARY_COLOR,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            print("ServerId CustomerId API :  ${AppVariables.ServerId}${AppVariables.CustomerId}${AppVariables.API}");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreenPage(),
                ));
          },
          child: Padding(
            padding: EdgeInsets.only(
              right: 130,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.login,
                  color: AppConstant.PRIMARY_COLOR,
                ),
                SizedBox(width: 8),
                Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(
                    fontSize: 18, color: AppConstant.PRIMARY_COLOR,
//                  color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        )
      ];
    } else {
      return <Widget>[
        Text(
          AppVariables.CUSTNAME,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: AppConstant.PRIMARY_COLOR,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          AppVariables.CUSTID,
          style: TextStyle(
            fontSize: 16,
            color: AppConstant.PRIMARY_COLOR,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () {
            AppConstant.delPayerId(AppVariables.CUSTTEL);
            AppVariables.IS_LOGIN = false;
            AppVariables.CUSTID = "-";
            AppVariables.CUSTNAME = "ลูกค้าทั่วไป";
            AppVariables.CUSTTEL = "-";
            _SaveLogin();

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
                (Route<dynamic> route) => false);
          },
          child: Padding(
            padding: EdgeInsets.only(
              right: 130,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.logout_outlined,
                  color: AppConstant.PRIMARY_COLOR,
                ),
                SizedBox(width: 8),
                Text(
                  "ออกจากระบบ",
                  style: TextStyle(
                    fontSize: 18, color: AppConstant.PRIMARY_COLOR,
//                  color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }
  }

  // ignore: non_constant_identifier_names
  void _SaveLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppConstant.IS_LOGIN_PREF, AppVariables.IS_LOGIN);
    prefs.setString(AppConstant.CUSTID_PREF, AppVariables.CUSTID);
    prefs.setString(AppConstant.CUSTNAME_PREF, AppVariables.CUSTNAME);
    prefs.setString(AppConstant.CUSTTEL_PREF, AppVariables.CUSTTEL);

    AppConstant.savePayerId(AppVariables.CUSTTEL);
  }
}

_makePhoneCall(String phoneNumber) async {
  final Uri url = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication); // ใช้ externalApplication
  } else {
    throw 'Could not launch $url';
  }
}

_launchUrlPolicy() async {
  Uri url = Uri.parse('https://sites.google.com/view/kanjanapisek/privacy-policy');

  if (await canLaunchUrl(url)) {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  }
  throw 'Could not launch url';
}

_launchUrlTerm() async {
  Uri url = Uri.parse('https://sites.google.com/view/kanjanapisek/term-conditions');

  if (await canLaunchUrl(url)) {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  }
  throw 'Could not launch url';
}
