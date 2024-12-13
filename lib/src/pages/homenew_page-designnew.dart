import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
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

    AppService().promotionBannerP1();
    AppService().newProductP1();
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
                image: AssetImage("assets/images/bg-home.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Color(0xFF990000),
                  title: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      children: [
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
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    ' Model App',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        height: 0.8),
                                  ),
                                  SizedBox(height: 10),
                                  AppVariables.CUSTID == "-"
                                      ? SizedBox()
                                      : Row(
                                          children: [
                                            Text(
                                              ' สวัสดี ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              AppVariables.CUSTNAME,
                                              style: TextStyle(
                                                  color: Color(0xFFfefca7),
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  toolbarHeight: 110,
                ),
                body: ListView(
                  children: [
                    SizedBox(height: 10),
                    goldPrice(context),
                    savingMt(appController),
                    pawnMT(appController),
                    promotionBanner(appController),
                    newProduct(appController),
                  ],
                )),
          );
        });
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
      height: MediaQuery.of(context).size.width * 0.30,
      child: FutureBuilder(
          future: fetchGoldPrice(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "ราคาทองคำแท่งวันที่ ${AppVariables.GoldPriceText}",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppConstant.PRIMARY_COLOR,
                        //color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFf0e19b),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.81,
                        height: 80,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.24,
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
                                            fontSize: 30,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ))
                                      : int.parse(AppVariables
                                                  .GoldPriceUpDown) ==
                                              0
                                          ? Text(
                                              " ${AppVariables.GoldPriceUpDown}",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ))
                                          : Text(
                                              " ${AppVariables.GoldPriceUpDown}",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Color(0xFFa61c1f),
                                                fontWeight: FontWeight.bold,
                                              )),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                // color: Constant.PRIMARY_COLOR,
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color(0xFF660000),
                                    Color(0xFFDC143C),
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                              ),
                              width: MediaQuery.of(context).size.width * 0.544,
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
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                return CircularProgressIndicator();
              }
            } else {
              return CircularProgressIndicator();
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
                  height: 160,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: appController.savingMts.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        appController.savingMts[index].savingId!;
                        print("${appController.savingMts[index].savingId}");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SavingPage(appController.savingMts[index]),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/saving.png"),
                                opacity: 0.50,
                              ),
                              // border: const GradientBoxBorder(
                              //   gradient: LinearGradient(
                              //       colors: [
                              //         Color(0xFFb57e10),
                              //         Color(0xFFf9df7b),
                              //         Color(0xFFb57e10)
                              //       ],
                              //       begin: Alignment.bottomLeft,
                              //       end: Alignment.topRight),
                              //   width: 3,
                              // ),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Container(
                                height: 130,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(width: 10),
                                    _buildTitelSaving(),
                                    _buildDetailSaving(appController, index,
                                        MediaQuery.of(context).size.width)
                                  ],
                                ),
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
                color: Color(0xFFfefca7),
                fontSize: 24),
            textScaleFactor: 1.0,
          ),
          SizedBox(height: 10),
          Text(
            "ยอดออมทอง  :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFfefca7),
                fontSize: 24),
            textScaleFactor: 1.0,
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
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
            textScaleFactor: 1.0,
          ),
          SizedBox(height: 10),
          Text(
            "  ${AppFormatters.formatNumber.format(appController.savingMts[index].totalPay)} บาท",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
            textScaleFactor: 1.0,
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
                color: Color(0xFFfefca7),
                fontSize: 22),
            textScaleFactor: 1,
          ),
          Text(
            "จำนวนเงิน :",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFfefca7),
                fontSize: 22),
            textScaleFactor: 1,
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
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
            textScaleFactor: 1,
          ),
          Text(
            " ${AppFormatters.formatNumber.format(appController.pawnMts[index].amountget)} บาท",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
            textScaleFactor: 1,
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

  Widget pawnMT(AppController appController) {
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
                      "รายการขายฝาก",
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
                    "ไม่พบรายการขายฝาก",
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
                        "รายการขายฝาก",
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
                  height: 160,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: appController.pawnMts.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        print("${appController.pawnMts[index].pawnId}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PawnDtPage(appController.pawnMts[index]),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/pawn.png"),
                                opacity: 0.4,
                              ),
                              // border: const GradientBoxBorder(
                              //   gradient: LinearGradient(
                              //       colors: [
                              //         Color(0xFFb57e10),
                              //         Color(0xFFf9df7b),
                              //         Color(0xFFb57e10)
                              //       ],
                              //       begin: Alignment.bottomLeft,
                              //       end: Alignment.topRight),
                              //   width: 3,
                              // ),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Container(
                                height: 130,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(width: 10),
                                    _buildTitelPawnMt(
                                        MediaQuery.of(context).size.width),
                                    _buildDetailPawnMt(appController, index,
                                        MediaQuery.of(context).size.width)
                                  ],
                                ),
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
                        Color(0xFF660000),
                        Color(0xFFDC143C),
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
                                color: Colors.white,
                                fontSize: 20,
                                height: 1.5),
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
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2.9),
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    appController.newProductP1s[index]
                                        .mobileAppPromotionLink,
                                  ),
                                ),
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
}
