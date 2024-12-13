import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home_page.dart';

class PasswordScreenPage extends StatefulWidget {
  final String mobileNumber;

  PasswordScreenPage({
    required this.mobileNumber,
  })  : assert(mobileNumber != null),
        super();

  @override
  _PasswordScreenPageState createState() => _PasswordScreenPageState();
}

class _PasswordScreenPageState extends State<PasswordScreenPage> {
  /// Control the input text field.
  TextEditingController _pinPasswordController = TextEditingController();
  TextEditingController _pinThaiIdController = TextEditingController();

  /// Decorate the outside of the Pin.
  // PinDecoration _pinDecoration =
  //     UnderlineDecoration(enteredColor: AppConstant.FONT_COLOR_MENU);
  // PinDecoration _pinThaiIdDecoration =
  //     UnderlineDecoration(enteredColor: AppConstant.FONT_COLOR_MENU);

  bool isValid = false;
  bool isThaiIdValid = false;

  Future<Null> validate(StateSetter updateState) async {
    print("in validate : ${_pinPasswordController.text.length}");
    if (_pinPasswordController.text.length == 6) {
      updateState(() {
        isValid = true;
      });
    } else {
      updateState(() {
        isValid = false;
      });
    }
  }

  Future<Null> validateThaiId(StateSetter updateState) async {
    print("in validate : ${_pinPasswordController.text.length}");
    if (_pinThaiIdController.text.length > 0 &&
        _pinThaiIdController.text == AppVariables.CUSTTHAIIDTEMP) {
      updateState(() {
        isThaiIdValid = true;
      });
    } else {
      updateState(() {
        isThaiIdValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("mobile ${widget.mobileNumber}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppVariables.MOBILEAPPPASSWORDTEMP.length == 6
              ? "เข้าสู่ระบบ รหัสลูกค้า ${AppVariables.CUSTIDTEMP}"
              : "บันทึกรหัสผ่านใหม่ รหัสลูกค้า ${AppVariables.CUSTIDTEMP}",
          style: TextStyle(color: AppConstant.FONT_COLOR_MENU, fontSize: 14),
        ),
        iconTheme: IconThemeData(
          color: AppConstant.FONT_COLOR_MENU,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child:
            StatefulBuilder(builder: (BuildContext context, StateSetter state) {
          return AppVariables.MOBILEAPPPASSWORDTEMP.length == 6
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      // child: PinInputTextField(
                      //   pinLength: 6,
                      //   decoration: _pinDecoration,
                      //   controller: _pinPasswordController,
                      //   autoFocus: true,
                      //   textInputAction: TextInputAction.done,
                      //   onChanged: (text) {
                      //     validate(state);
                      //   },
                      // ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          AppVariables.MOBILEAPPPASSWORDTEMP = "";
                          _pinPasswordController.text = "";
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Text(
                              "ลืมรหัสผ่าน",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppConstant.FONT_COLOR_MENU,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    !isValid
                        ? SizedBox(height: 0)
                        : Container(
                            padding: EdgeInsets.all(16),
                            //              child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                gradient: LinearGradient(
                                  colors: [
                                    AppConstant.PRIMARY_COLOR,
                                    AppConstant.SECONDARY_COLOR,
                                  ],
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: AppConstant.PRIMARY_COLOR,
                                    offset: Offset(1.0, 6.0),
                                    blurRadius: 20.0,
                                  ),
                                  BoxShadow(
                                    color: AppConstant.SECONDARY_COLOR,
                                    offset: Offset(1.0, 6.0),
                                    blurRadius: 20.0,
                                  ),
                                ],
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                //                    shape: RoundedRectangleBorder(
                                //                        borderRadius: BorderRadius.circular(0.0)),
                                child: Text(
                                  "ยืนยัน รหัสผ่าน",
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  if (isValid) {
                                    checkPassword();
                                  } else {
                                    validate(state);
                                  }
                                },
                                // padding: EdgeInsets.all(16.0),
                              ),
                            ),
                          ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    SizedBox(height: 15),
                    Text(
                      "เลขประจำตัวประชาชน",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppConstant.FONT_COLOR_MENU,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType: TextInputType.text,
                        controller: _pinThaiIdController,
                        autofocus: true,
                        onChanged: (text) {
                          validateThaiId(state);
                        },
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.perm_identity,
                          ),
                          labelText:
                              "ใส่เลขประจำตัวประชาชนที่ลงทะเบียนไว้กับร้าน",
                        ),
                        autocorrect: false,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        validator: (value) {
                          return !isThaiIdValid
                              ? 'กรุณาใส่เลขประจำตัวประชาชนให้ถูกต้อง'
                              : null;
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                    !isThaiIdValid
                        ? SizedBox(height: 0)
                        : Column(
                            children: [
                              Text(
                                "รหัสผ่านใหม่ 6 หลัก",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppConstant.FONT_COLOR_MENU,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                // child: PinInputTextField(
                                //   pinLength: 6,
                                //   decoration: _pinDecoration,
                                //   controller: _pinPasswordController,
                                //   autoFocus: true,
                                //   textInputAction: TextInputAction.done,
                                //   onChanged: (text) {
                                //     validate(state);
                                //   },
                                // ),
                              ),
                              !isValid
                                  ? SizedBox(height: 0)
                                  : Container(
                                      padding: EdgeInsets.all(16),
                                      //              child: Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          gradient: LinearGradient(
                                            colors: [
                                              AppConstant.PRIMARY_COLOR,
                                              AppConstant.SECONDARY_COLOR,
                                            ],
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: AppConstant.PRIMARY_COLOR,
                                              offset: Offset(1.0, 6.0),
                                              blurRadius: 20.0,
                                            ),
                                            BoxShadow(
                                              color:
                                                  AppConstant.SECONDARY_COLOR,
                                              offset: Offset(1.0, 6.0),
                                              blurRadius: 20.0,
                                            ),
                                          ],
                                        ),
                                        child: TextButton(
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                          ),
                                          //                    shape: RoundedRectangleBorder(
                                          //                        borderRadius: BorderRadius.circular(0.0)),
                                          child: Text(
                                            "เข้าสู่ระบบ และ บันทึกรหัสผ่านใหม่",
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            if (isValid) {
                                              ResetPassword(
                                                  _pinPasswordController.text);
                                            } else {
                                              validate(state);
                                            }
                                          },
                                          // padding: EdgeInsets.all(16.0),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                  ],
                );
        }),
      ),
    );
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: color,
        textColor: Color(0xFFf0e19b),
        fontSize: 16.0);
  }

  void _SaveLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppConstant.IS_LOGIN_PREF, AppVariables.IS_LOGIN);
    prefs.setString(AppConstant.CUSTID_PREF, AppVariables.CUSTID);
    prefs.setString(AppConstant.CUSTNAME_PREF, AppVariables.CUSTNAME);
    prefs.setString(AppConstant.CUSTTEL_PREF, AppVariables.CUSTTEL);
    prefs.setString(AppConstant.MEMBERID_PREF, AppVariables.MEMBERID);
    prefs.setString(AppConstant.CUSTTHAIID_PREF, AppVariables.CUSTTHAIID);

    // Constant.savePayerId(AppVariables.CUSTTEL);
  }

  void checkPassword() async {
    print(
        "password:${AppVariables.MOBILEAPPPASSWORDTEMP} password input:${_pinPasswordController.text}");
    if (AppVariables.MOBILEAPPPASSWORDTEMP == _pinPasswordController.text) {
      AppVariables.IS_LOGIN = true;
      AppVariables.CUSTID = AppVariables.CUSTIDTEMP;
      AppVariables.CUSTNAME = AppVariables.CUSTNAMETEMP;
      AppVariables.CUSTTEL = AppVariables.CUSTTELTEMP;
      AppVariables.MEMBERID = AppVariables.MEMBERIDTEMP;
      AppVariables.CUSTTHAIID = AppVariables.CUSTTHAIIDTEMP;
      _SaveLogin();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
          (Route<dynamic> route) => false);
    } else {
      showDialogInvid();
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load fetchCustTelAndCustId');
    }
  }

  Future ResetPassword(String mobileAppPassword) async {
    try {
      print("cancel jobnew");
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'serverId': AppVariables.ServerId,
        'customerId': AppVariables.CustomerId
      };
      final url =
          "${AppVariables.API}/customer/resetpassword?searchCustTel=${AppVariables.CUSTTELTEMP}&searchCustThaiId=${AppVariables.CUSTTHAIIDTEMP}&searchMobileAppPassword=${mobileAppPassword}";
      final response = await http.put(Uri.parse(url), headers: requestHeaders);
      print(url);
      if (response.statusCode == 204) {
        print("Reset Password");
        AppVariables.IS_LOGIN = true;
        AppVariables.CUSTID = AppVariables.CUSTIDTEMP;
        AppVariables.CUSTNAME = AppVariables.CUSTNAMETEMP;
        AppVariables.CUSTTEL = AppVariables.CUSTTELTEMP;
        AppVariables.MEMBERID = AppVariables.MEMBERIDTEMP;
        AppVariables.CUSTTHAIID = AppVariables.CUSTTHAIIDTEMP;
        _SaveLogin();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (Route<dynamic> route) => false);
      } else {
        showDialogNotCancel();
        print("Failed Reset Password ${response.statusCode}");
      }
    } catch (_) {
      showDialogNotCancel();
      print("${_}");
    }
  }

  void showDialogNotCancel() {
    showDialog(
      context: AppConstant.scaffoldKey.currentContext!,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'ไม่สามารถบันทึกรหัสผ่านได้ ลองใหม่อีกครั้ง',
            style: TextStyle(color: AppConstant.FONT_COLOR_MENU),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 20,
                  color: AppConstant.FONT_COLOR_MENU,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogInvid() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('เข้าสู่ระบบ',
              style: TextStyle(color: AppConstant.FONT_COLOR_MENU)),
          content: Text('รหัสไม่ถูกต้อง',
              style: TextStyle(color: AppConstant.FONT_COLOR_MENU)),
          actions: <Widget>[
            TextButton(
              child: Text('ตกลง',
                  style: TextStyle(color: AppConstant.FONT_COLOR_MENU)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}
