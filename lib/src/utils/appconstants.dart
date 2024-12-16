import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanjanapisek_app/src/pages/mobileappnotisent_page.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

class AppConstant {
  // URL API
  static String URL_BSSCONFIGAPI =
      "https://apiconfigservice-b2drcpbnehb5fubc.southeastasia-01.azurewebsites.net/customerconfig/custapp/kanjanapisek";

  static String OneSignalAppId = "d8c68732-1599-463c-af34-8192e039a95c";
  static String OneSignalRestkey =
      "ZWMwYmQxNWQtMWNlNy00YWRmLWJkNTMtZDk3NjllM2Q3YmIy";

  // shared preferences
  static const String IS_LOGIN_PREF = "is_login";
  static const String CUSTID_PREF = "custid";
  static const String CUSTNAME_PREF = "custname";
  static const String CUSTTEL_PREF = "custtel";
  static const String CUSTTHAIID_PREF = "custthaiid";
  static const String MEMBERID_PREF = "memberid";

  //routes
  static const String HOME_ROUTE = "/home";
  static const String LOGIN_ROUTE = "/login";
  static const String DETAIL_ROUTE = "/youtube detail";
  static const String FAVORITE_ROUTE = "/favorite";
  static const String MAP_ROUTE = "/map";
  static const String TIMELINE_ROUTE = "/timeline";
  static const String SAVING_ROUTE = "/saving";
  static const String POINT_ROUTE = "/point";
  static const String PAWN_ROUTE = "/pawn";
  static const String SETTING_ROUTE = "/setting";

  //fonts
  static const String QUICK_SAND_FONT = "Quicksand";
  static const String KANIT_FONT = "Kanit";

  //images
  static const String IMAGE_DIR = "assets/images";
  static const String HEADER_1_IMAGE = "$IMAGE_DIR/header_1.png";
  static const String HEADER_2_IMAGE = "$IMAGE_DIR/header_2.png";
  static const String HEADER_3_IMAGE = "$IMAGE_DIR/header_3.png";
  static const String CMDEV_LOGO_IMAGE = "$IMAGE_DIR/cmdev_logo.png";
  static const String PIN_MARKER = "$IMAGE_DIR/pin_marker.png";
  static const String PIN_CURRENT = "$IMAGE_DIR/pin_current.png";

  //color
  // static const Color PRIMARY_COLOR = Colors.blue;
  static const Color BLUE_COLOR = Colors.blueAccent;
  static const Color GRAY_COLOR = Color(0xFF666666);
  static const Color BG_COLOR = Color(0xFFF4F6F8);
  static const Color BG_WHITE_COLOR = Color(0xFFFFFFFF);
  static const Color BG_LOAD_COLOR = Color(0xFFe1e5e7);

  // static Color PRIMARY_COLOR = Colors.blueGrey[600];
  // static Color SECONDARY_COLOR = Colors.blueGrey[200];
  static final Color PRIMARY_COLOR = Color(0xFF990000);
  static final Color SECONDARY_COLOR = Color(0xFF990000);
  static final Color FONTHEAD_COLOR = Color(0xFFb60521);
  static final Color FONT_COLOR = Colors.white;

  // static Color FONT_COLOR_MENU = Colors.blueGrey[600];
  static final Color FONT_COLOR_MENU = Color(0xFF99000);
  static final Color FONT_COLOR_PAGE = Color(0xFFFFFFFF);

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  // static DateTime SelectDate = DateTime.now();
  // static TimeOfDay SelectTime = TimeOfDay.now();

  static void handleClickNotification(BuildContext context) {
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      try {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MobileAppNotiSentPage()));
      } catch (e, stacktrace) {
        print(e);
      }
    });
  }

  static void delPayerId(String Custtel) async {
    // ลบ payer id ลง sql
    try {
      final status = await OneSignal.shared.getDeviceState();
      final String? osUserID = status?.userId;
      print("Payer Id : ${osUserID}");

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'serverId': AppVariables.ServerId,
        'customerId': AppVariables.CustomerId
      };

      final url =
          '${AppVariables.API}/mobileappnoticonfig/deluser?custtel=${Custtel}&onesignaluserid=${osUserID}';
      final response = await http.put(Uri.parse(url), headers: requestHeaders);
      print(url);
      if (response.statusCode == 204) {
        print('del user complete ${Custtel}');
      } else {
        print('Failed to load del ${response.statusCode}');
      }
    } catch (_) {
      print("Error catch ${_}");
    }
  }

  static void savePayerId(String Custtel) async {
    // เพิ่ม payer id ลง sql
    try {
      final status = await OneSignal.shared.getDeviceState();
      final String? osUserID = status?.userId;
      print("Payer Id : ${osUserID}");

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'serverId': AppVariables.ServerId,
        'customerId': AppVariables.CustomerId
      };

      final url =
          '${AppVariables.API}/mobileappnoticonfig/adduser?custtel=${Custtel}&onesignaluserid=${osUserID}';
      final response = await http.put(Uri.parse(url), headers: requestHeaders);
      print(url);
      if (response.statusCode == 204) {
        print('save user complete ${Custtel}');
      } else {
        print('Failed to load save ${response.statusCode}');
      }
    } catch (_) {
      print("Error catch ${_}");
    }
  }
}
