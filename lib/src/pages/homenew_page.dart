import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:kanjanapisek_app/src/pages/home_page.dart';
import 'package:kanjanapisek_app/src/pages/loginscreen_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanjanapisek_app/src/models/mobileappnotisentcountunread_response.dart';
import 'package:kanjanapisek_app/src/pages/mobileappnotisent_page.dart';
import 'package:kanjanapisek_app/src/pages/productrecommend_page.dart';
import 'package:kanjanapisek_app/src/services/app_service.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';
import 'package:kanjanapisek_app/src/utils/appcontroller.dart';
import 'package:kanjanapisek_app/src/utils/appformatters.dart';
import 'package:kanjanapisek_app/src/widgets/goldprice.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNew extends StatefulWidget {
  @override
  State<HomeNew> createState() => _HomeNewState();
}

class _HomeNewState extends State<HomeNew> {
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
    AppService().mobileAppNotiSent();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(appController.mobileAppNotiSents);
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                image: AssetImage("assets/images/bg-homenew.png"),
                fit: BoxFit.cover,
                ),
                ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Color(0xFFb60521),
                  title: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 120,
                              width: MediaQuery.of(context).size.width * 0.2,
                            ),
                            SizedBox(
                              height: 120,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/logo.png',
                                    width: 120,
                                    height: 120,
                                  ),
                                ],
                              ),
                            ),
                            // notiButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  toolbarHeight: 140,
                ),
                body: ListView(
                  children: [
                    SizedBox(height: 10),
                    goldPrice(context),
                    // newProduct(appController),
                    whatNew(context,appController)
                  ],
                )),
          );
        });
  }

  Column whatNew(BuildContext context, AppController appController) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFb60521),
                Color(0xFF990000),
                Color(0xFFb60521),
              ],
            ),
          ),
          height: 60,
          width: MediaQuery.of(context).size.width * 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "  มีอะไรใหม่",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  height: 1,
                ),
                textScaler: TextScaler.linear(1),
              ),
              notiButton(),
            ],
          ),
        ),
        Container(
            child: appController.mobileAppNotiSents.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text("ท่านยังไม่ได้ เข้าสู่ระบบ เข้าใช้งาน",
                            style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 8, 1, 1)),
                            textScaler: TextScaler.linear(1)),
                        Text("กรุณากดเข้าสู่ระบบเพื่อแสดงรายการ",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                            textScaler: TextScaler.linear(1)),
                            ..._buildLogInOut(context),
                      ],
                    ),
                  )
                : SizedBox(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: appController.mobileAppNotiSents.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 1,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFF5E2),
                                  border: Border(
                                      bottom: BorderSide(color: Colors.black))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.notifications,
                                            ),
                                            Text(
                                                appController
                                                    .mobileAppNotiSents[index]
                                                    .notiTitle!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                                textAlign: TextAlign.left,
                                                 textScaler: TextScaler.linear(1)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              AppFormatters.formatDate.format(
                                                  appController
                                                      .mobileAppNotiSents[index]
                                                      .notiDate!),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              appController
                                                  .mobileAppNotiSents[index]
                                                  .notiTime!,
                                                   textScaler: TextScaler.linear(1)
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    appController.mobileAppNotiSents[index]
                                                .notiRefNo ==
                                            ""
                                        ? SizedBox()
                                        : Text(
                                            "เลขที่ ${appController.mobileAppNotiSents[index].notiRefNo}",
                                             textScaler: TextScaler.linear(1)
                                          ),
                                    Text(appController
                                        .mobileAppNotiSents[index].notiDetail!, textScaler: TextScaler.linear(1)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
      ],
    );
  }

  Padding notiButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FutureBuilder(
          future: getNotiUnread(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return Container(
                    //color: Constant.FONT_COLOR_MENU,
                    decoration: BoxDecoration(
                        //color: Color(0xFFe7b971),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(
                          15,
                        )),
                        border: Border.all(color: Color(0xFFb60521))),
                    child: AppVariables.CountUnreadNoti == 0
                        ? IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: Color(0xFF990000),
                              //color: Constant.PRIMARY_COLOR,
                            ),
                            onPressed: () {
                              AppVariables.searchNotiDateStart = null;
                              AppVariables.searchNotiDateEnd = null;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MobileAppNotiSentPage(),
                                  ));
                            })
                        : IconButton(
                            icon: badges.Badge(
                              position:
                                  badges.BadgePosition.topEnd(top: -7, end: -7),
                              badgeContent:
                                  Text(AppVariables.CountUnreadNoti.toString(),
                                      style: TextStyle(
                                          color: Color(0xFFf0e19b),
                                          //color: Constant.PRIMARY_COLOR,
                                          fontWeight: FontWeight.bold)),
                              child: Icon(
                                Icons.notifications,
                                color: Color(0xFFf0e19b),
                                //color: Constant.PRIMARY_COLOR,
                              ),
                            ),
                            onPressed: () async {
                              try {
                                print("updateNotiUnread");
                                Map<String, String> requestHeaders = {
                                  'Content-type': 'application/json',
                                  'serverId': AppVariables.ServerId,
                                  'customerId': AppVariables.CustomerId
                                };
                                final url =
                                    "${AppVariables.API}/MobileAppNotiSentUpdateCount?searchCustTel=${AppVariables.CUSTTEL}";
                                final response = await http.put(Uri.parse(url),
                                    headers: requestHeaders);
                                print(response.statusCode);
                                print("MobileAppNotiSentUpdateCount : ${url}");
                              } catch (_) {
                                print("${_}");
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MobileAppNotiSentPage(),
                                  ));
                              setState(() {
                                AppVariables.CountUnreadNoti = 0;
                              });
                            }));
              } else {
                return CircularProgressIndicator();
              }
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget menuHit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Container(
          height: 30,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "รายการยอดฮิต",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  height: 1,
                ),
                textScaler: TextScaler.linear(1),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/images/btnsaving.png',
                      height: 80,
                    )),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: ((context) => SavingPage())));
                },
              ),
              InkWell(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/images/btnpawn.png',
                      height: 80,
                    )),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: ((context) => PawnPage())));
                },
              ),
              InkWell(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/images/btnsetting.png',
                      height: 80,
                    )),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: ((context) => ProfilePage())));
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget goldPrice(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: 150,
      child: FutureBuilder(
          future: fetchGoldPrice(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color(0xFFb60521),
                                Color(0xFF990000),
                              ],
                            ),
                            // color: Constant.PRIMARY_COLOR,
                            borderRadius: BorderRadius.all(Radius.circular(
                              15,
                            ))),
                        width: MediaQuery.of(context).size.width * 1,
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ราคาทองคำแท่งวันที่ ${AppVariables.GoldPriceText}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                  //color: Colors.blueGrey,
                                  ),
                              textScaler: TextScaler.linear(1),
                            ),
                            // SizedBox(
                            //   width: 15,
                            // ),
                            // Text(
                            //   DateFormat('dd/MM/yyyy').format(DateTime.now()),
                            //   style: TextStyle(
                            //     fontSize: 20,
                            //     color: Color(0xFFf0e19b),
                            //     //color: Colors.blueGrey,
                            //   ),
                            // ),
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFf0e19b),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.82,
                        height: 80,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  int.parse(AppVariables.GoldPriceUpDown) > 0
                                      ? Icon(
                                          Icons.arrow_upward,
                                          size: 30,
                                          color: Colors.green,
                                        )
                                      : int.parse(AppVariables
                                                  .GoldPriceUpDown) ==
                                              0
                                          ? Text("")
                                          : Icon(
                                              Icons.arrow_downward,
                                              size: 30,
                                              color: Color(0xFFa61c1f),
                                            ),
                                  int.parse(AppVariables.GoldPriceUpDown) > 0
                                      ? Text(" ${AppVariables.GoldPriceUpDown}",
                                          style: TextStyle(
                                            fontSize: 28,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaler: TextScaler.linear(1))
                                      : int.parse(AppVariables
                                                  .GoldPriceUpDown) ==
                                              0
                                          ? Text(
                                              " ${AppVariables.GoldPriceUpDown}",
                                              style: TextStyle(
                                                fontSize: 28,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textScaler: TextScaler.linear(1))
                                          : Text(
                                              " ${AppVariables.GoldPriceUpDown}",
                                              style: TextStyle(
                                                fontSize: 28,
                                                color: Color(0xFFa61c1f),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textScaler: TextScaler.linear(1)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Color(0xFFb60521),
                                    Color(0xFF990000),
                                    Color(0xFFb60521),
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                              ),
                              width: MediaQuery.of(context).size.width * 0.536,
                              height: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Text(
                                          " ขายออก",
                                          style: TextStyle(
                                            // color: Color(0xFFfefca7),
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaler: TextScaler.linear(1),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          AppVariables.GoldPriceSale,
                                          style: TextStyle(
                                            // color: Color(0xFFfefca7),
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaler: TextScaler.linear(1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Text(
                                          " รับซื้อ",
                                          style: TextStyle(
                                            // color: Color(0xFFfefca7),
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaler: TextScaler.linear(1),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          AppVariables.GoldPriceBuy,
                                          style: TextStyle(
                                            // color: Color(0xFFfefca7),
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaler: TextScaler.linear(1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                );
              } else {
              return  Text("...ไม่พบราคาทองวันนี้...", textScaler: TextScaler.linear(1));
              }
            } else {
              return  Text("...ไม่พบราคาทองวันนี้...", textScaler: TextScaler.linear(1));
            }
          }),
    );
  }

  Widget promotionBanner(AppController appController) {
    return Container(
      child: appController.productModels.isEmpty
          ? SizedBox()
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ข่าวสารและโปรโมชั่น",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          height: 1.5,
                        ),
                        textScaler: TextScaler.linear(1),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: appController.productModels.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => TimeLineImagePage(
                        //           post: appController.productModels[index]),
                        //     ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          // decoration: BoxDecoration(
                          //     border: const GradientBoxBorder(
                          //       gradient: LinearGradient(
                          //           colors: [
                          //             Color(0xFFb57e10),
                          //             Color(0xFFf9df7b),
                          //             Color(0xFFb57e10)
                          //           ],
                          //           begin: Alignment.bottomLeft,
                          //           end: Alignment.topRight),
                          //       width: 3,
                          //     ),
                          //     borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              appController.productModels[index]
                                  .mobileAppPromotionCoverLink,
                              // width: 280,
                              // height: 180,
                            ),
                          ),
                        ),
                      ),
                    ),
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
            "เลขที่ออมทอง  :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 24),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 10),
          Text(
            "ยอดออมทอง  :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 24),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 5),
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
            "  ${appController.savingMts[index].savingId}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 24),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 10),
          Text(
            "  ${AppFormatters.formatNumber.format(appController.savingMts[index].totalPay)} บาท",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 24),
            textScaler: TextScaler.linear(1),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildTitelPawnMt(double width) {
    return Container(
      width: width * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            "เลขที่ขายฝาก :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 22),
            textScaler: TextScaler.linear(1),
          ),
          Text(
            "จำนวนเงิน :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 22),
            textScaler: TextScaler.linear(1),
          ),
          // Text(
          //   "วันที่ครบกำหนด :",
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Color(0xFFfefca7),
          //       fontSize: 22),
          //   textScaleFactor: 1,
          // ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildDetailPawnMt(
      AppController appController, int index, double width) {
    return Container(
      width: width * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            " ${appController.pawnMts[index].pawnId}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 22),
            textScaler: TextScaler.linear(1),
          ),
          Text(
            " ${AppFormatters.formatNumber.format(appController.pawnMts[index].amountget)} บาท",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.SECONDARY_COLOR,
                fontSize: 22),
            textScaler: TextScaler.linear(1),
          ),
          // Text(
          //   " ${Constant.formatDate.format(appController.pawnMts[index].duedate)}",
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
          //   textScaleFactor: 1,
          // ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget newProduct(AppController appController) {
    return Container(
      child: appController.newProductP1s.isEmpty
          ? SizedBox()
          : Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xFFb60521),
                        Color(0xFF990000),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "  สินค้าแนะนำ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            "ดูสินค้าทั้งหมด  ",
                            style: TextStyle(
                                color: Colors.white, fontSize: 20, height: 1.5),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductRecommendPage(),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => TimeLineImagePage(
                        //           post: appController.newProductP1s[index]),
                        //     ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: const GradientBoxBorder(
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFb60521),
                                          Color(0xFF990000),
                                          Color(0xFFb60521)
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight),
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      height: 200,
                                      width: 400,
                                      imageUrl: kIsWeb
                                          ? "https://api.allorigins.win/raw?url=${appController.newProductP1s[index].mobileAppPromotionLink}"
                                          : appController.newProductP1s[index]
                                              .mobileAppPromotionLink,
                                      placeholder: (context, url) =>
                                          Image.network(
                                        appController.newProductP1s[index]
                                            .mobileAppPromotionLink,
                                      ),
                                      // CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildLogInOut(BuildContext context) {
    if (AppVariables.CUSTID == "-") {
      return <Widget>[
        InkWell(
          onTap: () {
            print(
                "ServerId CustomerId API :  ${AppVariables.ServerId}${AppVariables.CustomerId}${AppVariables.API}");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreenPage(),
                ));
          },
          child: Padding(
            padding: EdgeInsets.only(
              right: 50,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.login,
                  color:AppConstant.PRIMARY_COLOR,
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
              right: 50,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.logout_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  "ออกจากระบบ",
                  style: TextStyle(
                    fontSize: 18, color: Colors.black,
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

Future<bool> getNotiUnread() async {
  AppVariables.CountUnreadNoti = 0;
  try {
    print("getNotiUnread");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'serverId': AppVariables.ServerId,
      'customerId': AppVariables.CustomerId
    };
    final url =
        "${AppVariables.API}/GetMobileAppNotiSentCountUnread?searchCustTel=${AppVariables.CUSTTEL}";
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    print(url);
    print("MobileAppNotiSentCountUnreadResponse : ${url}");
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final MobileAppNotiSentCountUnreadResponse
          mobileAppNotiSentCountUnreadResponse =
          MobileAppNotiSentCountUnreadResponse.fromJson(
              json.decode(response.body));
      AppVariables.CountUnreadNoti =
          mobileAppNotiSentCountUnreadResponse.countUnread!;
      print("MobileAppNotiSentCountUnreadResponse Complete");
      return true;
    } else {
      print("Failed to load SummaryResponse ${response.statusCode}");
      return false;
    }
  } catch (_) {
    print("${_}");
    return false;
  }
}
