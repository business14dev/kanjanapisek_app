import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanjanapisek_app/src/pages/home_page.dart';
import 'package:kanjanapisek_app/src/pages/loginscreen_page.dart';
import 'package:kanjanapisek_app/src/pages/pawndt_page.dart';
import 'package:kanjanapisek_app/src/pages/productrecommend_page.dart';
import 'package:kanjanapisek_app/src/pages/saving_page.dart';
import 'package:kanjanapisek_app/src/services/app_service.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';
import 'package:kanjanapisek_app/src/utils/appcontroller.dart';
import 'package:kanjanapisek_app/src/utils/appformatters.dart';
import 'package:kanjanapisek_app/src/widgets/goldprice.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavingmtPage extends StatefulWidget {
  @override
  State<SavingmtPage> createState() => _SavingmtPageState();
}

class _SavingmtPageState extends State<SavingmtPage> {
  @override
  File? _image;
  String _custId = AppVariables.CUSTID;

// ฟังก์ชันสำหรับเลือกรูปจาก gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File savedImage = await _saveImageToLocalDirectory(File(pickedFile.path));
      setState(() {
        _image = savedImage; // เซ็ตค่าให้แสดงรูปที่เลือก
      });
      _saveImagePath(savedImage.path);
    }
  }

  // ฟังก์ชันสำหรับบันทึกรูปภาพไปยัง Local Storage
  Future<File> _saveImageToLocalDirectory(File image) async {
    final directory =
        await getApplicationDocumentsDirectory(); // หา directory ที่แอปจะสามารถบันทึกไฟล์ได้
    final fileName = path.basename(image.path); // ดึงชื่อไฟล์
    final savedImage =
        await image.copy('${directory.path}/$fileName'); // ทำการบันทึกไฟล์

    return savedImage; // ส่งคืนไฟล์ที่ถูกบันทึก
  }

  Future<void> _saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_image_path', imagePath);
  }

  // โหลด path ของรูปจาก SharedPreferences และแสดงผลใน UI
  Future<void> _loadSavedImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('avatar_image_path');

    if (_custId != "-" && imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _image = File(imagePath); // โหลดรูปภาพจาก path ที่บันทึกไว้
      });
    }
  }

  void initState() {
    super.initState();
    _loadSavedImage();
    AppService().savingMtList();
    AppService().pawnMtList();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg-setting5.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Color(0xFF990000),
                  title: Container(
                    width: MediaQuery.of(context).size.width *1,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _custId != "-" ? _pickImage : () {},
                              child: _image != null && _custId != "-"
                                  ? CircleAvatar(
                                      radius: 40,
                                      backgroundImage: FileImage(_image!),
                                    )
                                  : Image.asset(
                                      "assets/images/avatar.png",
                                      height: 80,
                                    ),
                            ),
                            SizedBox(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  AppVariables.CUSTID == "-"
                                      ? Row(
                                          children: [
                                            Text(
                                              'ท่านยังไม่ได้ เข้าสู่ระบบ เข้าใช้งาน',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                           
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              ' สวัสดี ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              AppVariables.CUSTNAME,
                                              style: TextStyle(
                                                  color: Color(0xFFfefca7),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              textScaler: TextScaler.linear(1),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                           
                            
                          ],
                          
                        ),
                        
                      ],
                    ),
                  ),
                  toolbarHeight: 90,
                ),
                body: ListView(
                  children: [
                    SizedBox(height: 10),
                    savingMt(appController),
                  ],
                )),
          );
        });
  }

  Widget savingMt(AppController appController) {
    return Container(
      child: appController.savingMts.isEmpty
          ? Column(children: [
              // SizedBox(height: 5),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF660000),
                      Color(0xFFDC143C),
                    ],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "รายการออมทอง",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 180,
                child: Center(
                  child: Text(
                    "ไม่พบรายการออมทอง",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppConstant.PRIMARY_COLOR,
                      height: 1.5,
                    ),
                  ),
                ),
              )
            ])
          : Column(
              children: [
                // SizedBox(height: 5),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xFF660000),
                        Color(0xFFDC143C),
                      ],
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "รายการออมทอง",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  // height: 230,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 190,
                        child: GetBuilder<AppController>(builder: (controller) {
                          // ฟังการเลื่อน
                          controller.saivngScrollController.addListener(() {
                            controller.updateIndexOnScroll();
                          });
                          return ListView.builder(
                            controller: controller.saivngScrollController,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: appController.savingMts.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                appController.savingMts[index].savingId!;
                                print(
                                    "${appController.savingMts[index].savingId}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SavingPage(
                                          appController.savingMts[index]),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/saving.png"),
                                        opacity: 0.30,
                                      ),
                                      border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                          style: BorderStyle.solid),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color(0xFF660000),
                                          Color(0xFFDC143C),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            _buildTitelSaving(),
                                            _buildDetailSaving(
                                                appController,
                                                index,
                                                MediaQuery.of(context)
                                                    .size
                                                    .width)
                                          ],
                                        ),
                                      ),
                                    ],
                                    
                                  ),
                                  
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      GetBuilder<AppController>(builder: (controller) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            appController.savingMts.length,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index ==
                                            appController.selectedIndexSaving
                                        ? Colors.redAccent
                                        : Colors.grey),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTitelSaving() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            "สาขาที่ทำรายกการ  :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17),
            textScaler: TextScaler.linear(1),
          ),
            SizedBox(height: 10),
          Text(
            "เลขที่ออมทอง  :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17),
            textScaler: TextScaler.linear(1),
          ),
            SizedBox(height: 10),
          Text(
            "วันที่เปิดออม  :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 10),
          Text(
            "ยอดออมทอง  :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17),
            textScaler: TextScaler.linear(1),
          ),
         
          
        ],
      ),
    );
  }
  


  Widget _buildDetailSaving(
      AppController appController, int index, double width) {
    return Container(
      width: width * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
            Text(
            "  ${appController.savingMts[index].branchName}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 10),
          Text(
            "  ${appController.savingMts[index].savingId}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17),
            textScaler: TextScaler.linear(1),
          ),
           SizedBox(height: 10),
          Text(
            "  ${AppFormatters.formatDate.format(appController.savingMts[index].savingDate!)}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 10),
          Text(
            "  ${AppFormatters.formatNumber.format(appController.savingMts[index].totalPay)} บาท",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17),
            textScaler: TextScaler.linear(1),
          ),
        ],
      ),
    );
  }

}


   List<Widget> _buildLogInOut(BuildContext context) {
    if (AppVariables.CUSTID == "-") {
      return <Widget>[
        // Text(
        //   AppVariables.CUSTNAME,
        //   style: TextStyle(
        //     fontWeight: FontWeight.w700,
        //     fontSize: 20,
        //     color: AppConstant.PRIMARY_COLOR,
        //   ),
        // ),
        // SizedBox(
        //   height: 5,
        // ),
        // Text(
        //   AppVariables.CUSTID,
        //   style: TextStyle(
        //     fontSize: 14,
        //     color: AppConstant.PRIMARY_COLOR,
        //   ),
        // ),
        // SizedBox(
        //   height: 10,
        // ),
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
              right: 10,
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
        // Text(
        //   AppVariables.CUSTNAME,
        //   style: TextStyle(
        //     fontWeight: FontWeight.w700,
        //     fontSize: 22,
        //     color: AppConstant.PRIMARY_COLOR,
        //   ),
        // ),
        // SizedBox(
        //   height: 5,
        // ),
        // Text(
        //   AppVariables.CUSTID,
        //   style: TextStyle(
        //     fontSize: 16,
        //     color: AppConstant.PRIMARY_COLOR,
        //   ),
        // ),
        // SizedBox(
        //   height: 5,
        // ),
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
              right: 10,
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
 

