import 'dart:convert';
import 'dart:io';

import 'package:counter_button/counter_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:kanjanapisek_app/src/models/mobileapppaymentint_response.dart';
import 'package:kanjanapisek_app/src/pages/home_page.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:kanjanapisek_app/src/utils/appformatters.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';
import 'package:kanjanapisek_app/src/utils/banknameandimage.dart';
import 'package:kanjanapisek_app/src/widgets/selectdatetime.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UploadSlipIntPage extends StatefulWidget {
  final String branchNameAndPawnId;

  UploadSlipIntPage(this.branchNameAndPawnId);

  @override
  _UploadSlipIntPageState createState() => _UploadSlipIntPageState();
}

TextEditingController timeinput = TextEditingController();
TextEditingController amountPay = TextEditingController();

class _UploadSlipIntPageState extends State<UploadSlipIntPage> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  String? promptPayID;
  MobileAppPaymentIntResponse _mobileAppPaymentIntResponse =
      MobileAppPaymentIntResponse();

  dynamic _imageFile;
  DateTime _selectedDate = DateTime.now();
  int _counterValue = 1;

  @override
  void initState() {
    DateFormat dateFormat = DateFormat("HH:mm");
    timeinput.text = dateFormat.format(DateTime.now());
    amountPay.text = AppFormatters.formatNumber.format(
        double.parse(AppVariables.IntPerMonth.toString().replaceAll(",", "")) *
            _counterValue);
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(
            "เพิ่มรูปสลิปโอน จ่ายค่าธรรมเนียม ${AppVariables.MobileAppPaymentIntBillId}",
            style: TextStyle(color: AppConstant.PRIMARY_COLOR,fontSize: 18),textScaler: TextScaler.linear(1),
          ),
          iconTheme: IconThemeData(
            color: AppConstant.PRIMARY_COLOR,
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          height: double.infinity,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    "ค่าธรรมเนียมเดือนละ ${AppVariables.IntPerMonth} บาท",
                    style: TextStyle(
                      fontSize: 24,
                      color: AppConstant.FONT_COLOR_MENU,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "จำนวน",
                        style: TextStyle(
                          fontSize: 24,
                          color: AppConstant.FONT_COLOR_MENU,
                        ),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: CounterButton(
                          loading: false,
                          onChange: (int val) {
                            setState(() {
                              if (val <= 0) {
                                _counterValue = 1;
                              } else {
                                _counterValue = val;
                              }

                              amountPay.text = AppFormatters.formatNumber
                                  .format(double.parse(
                                          AppVariables.IntPerMonth.toString()
                                              .replaceAll(",", "")) *
                                      _counterValue);
                            });
                          },
                          count: _counterValue,
                          countColor: AppConstant.FONT_COLOR_MENU,
                          buttonColor: AppConstant.FONT_COLOR_MENU,
                          progressColor: AppConstant.FONT_COLOR_MENU,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "เดือน",
                        style: TextStyle(
                          fontSize: 24,
                          color: AppConstant.FONT_COLOR_MENU,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          readOnly: true,
                          controller: amountPay,
                          onSaved: (price) {
                            _mobileAppPaymentIntResponse.price = double.parse(
                                price.toString().replaceAll(",", ""));
                          },
                          validator: RequiredValidator(
                              errorText: "กรุณาใส่จำนวนเงินที่โอน"),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppConstant.FONT_COLOR_MENU,
                          ),
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          decoration: InputDecoration(
                              labelText: "จำนวนเงินที่โอน",
                              labelStyle: TextStyle(
                                  color: AppConstant.FONT_COLOR_MENU,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppConstant.FONT_COLOR_MENU))),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: new AssetImage(getBankImage(AppVariables.BankAccInt)))),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppVariables.BankAccInt,
                            style: TextStyle(
                              fontSize: 20,
                              color: AppConstant.FONT_COLOR_MENU,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            AppVariables.BankAcctNameInt,
                            style: TextStyle(
                              fontSize: 20,
                              color: AppConstant.FONT_COLOR_MENU,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                AppVariables.BankAcctNoInt,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppConstant.FONT_COLOR_MENU,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: AppConstant.FONT_COLOR_MENU,
                                  ),
                                  onPressed: () async {
                                    

                                      await Clipboard.setData(ClipboardData(
                                          text: AppVariables.BankAcctNoInt));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Copied to clipboard'),
                                      ));
                                    }
                                  ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                  // Container(
                  //   padding: EdgeInsets.only(left: 10, right: 10),
                  //   child: Center(
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width * 0.8,
                  //       decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //           begin: Alignment.bottomCenter,
                  //           end: Alignment.topCenter,
                  //           colors: [
                  //             Color(0xFFe8aa24),
                  //             Color(0xFFe8aa24),
                  //           ],
                  //         ),
                  //         borderRadius: BorderRadius.all(Radius.circular(25)),
                  //       ),
                  //       child: TextButton(
                  //         style: ButtonStyle(
                  //           foregroundColor:
                  //               MaterialStateProperty.all<Color>(Colors.white),
                  //         ),
                  //         child: Text(
                  //           'สร้าง QR Code พร้อมเพย์',
                  //           style: TextStyle(
                  //             fontSize: 20.0,
                  //             fontWeight: FontWeight.bold,
                  //             color: Color(0xFFFFFFFF),
                  //           ),
                  //         ),
                  //         // ignore: missing_return

                  //         onPressed: () {
                  //           promptPayID = "0849726380";

                  //           // แปลงค่า amountPay.text เป็น double เพื่อตรวจสอบจำนวนเงิน
                  //           final amount = double.tryParse(
                  //               amountPay.text.replaceAll(",", ""));

                  //           if (amount != null && amount > 0) {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) => QRCodePromptpayIntPage(
                  //                     title:
                  //                         "${AppVariables.MobileAppPaymentIntType} ${AppVariables.MobileAppPaymentIntBillId}",
                  //                     amount: amount),
                  //               ),
                  //             );
                  //           } else {
                  //             ScaffoldMessenger.of(context).showSnackBar(
                  //               SnackBar(
                  //                   content:
                  //                       Text("กรุณาใส่จำนวนเงินที่ถูกต้อง")),
                  //             );
                  //           }
                  //         },
                  //         //padding: EdgeInsets.all(16.0),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  Container(
                    child: _imageFile == null
                        ? Column(
                            children: [
                              Container(
                                height: 150,
                                child: Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 150,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              Text("เลือกรูป หรือ ถ่ายรูป สลิป",
                                  style: TextStyle(color: Colors.red))
                            ],
                          )
                        : Container(
                            child: kIsWeb
                                ? Image.memory(
                                    _imageFile!, // ใช้สำหรับเว็บ (Uint8List)
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    _imageFile!, // ใช้สำหรับ Android/iOS (File)
                                    fit: BoxFit.cover,
                                  ),
                          ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFF660000),
                              Color(0xFFDC143C),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: Text(
                            'เลือกรูปสลิป',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          // ignore: missing_return
                          onPressed: () {
                            _getFromGallery();
                          },
                          //padding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFF660000),
                              Color(0xFFDC143C),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFf0e19b)),
                          ),
                          child: Text(
                            'ถ่ายรูปสลิป',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          // ignore: missing_return
                          onPressed: () {
                            _getFromCamera();
                          },
                          //padding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                            colors: [
                              AppConstant.PRIMARY_COLOR,
                              AppConstant.SECONDARY_COLOR,
                            ],
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppConstant.PRIMARY_COLOR,
                              //offset: Offset(1.0, 6.0),
                              //blurRadius: 20.0,
                            ),
                            BoxShadow(
                              color: AppConstant.SECONDARY_COLOR,
                              //offset: Offset(1.0, 6.0),
                              //blurRadius: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFF660000),
                              Color(0xFFDC143C),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: Text(
                            "วันที่โอน ${AppFormatters.formatDate.format(AppVariables.SelectDate)}",
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          // ignore: missing_return
                          onPressed: () async {
                            DateTime? selectedDate =
                                await selectDate(context, DateTime.now());
                            if (selectedDate != null) {
                              setState(() {
                                print("Selected date: $selectedDate");
                              });
                            }
                          },
                          //padding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          controller: timeinput,
                          onSaved: (timeTran) {
                            _mobileAppPaymentIntResponse.timeTran = timeTran;
                          },
                          validator:
                              RequiredValidator(errorText: "กรุณาใส่เวลาโอน"),
                          style: TextStyle(
                            fontSize: 24,
                            color: AppConstant.FONT_COLOR_MENU,
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "เวลาโอน",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          onSaved: (remark) {
                            _mobileAppPaymentIntResponse.remark = remark;
                          },
                          style: TextStyle(
                              fontSize: 24, color: AppConstant.FONT_COLOR_MENU),
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "หมายเหตุ (ถ้ามี)",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFF660000),
                              Color(0xFFDC143C),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            child: Text(
                              "บันทึก",
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            // ignore: missing_return
                            onPressed: () async {
                              var statusCode;

                              if (_imageFile != null) {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  try {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Container(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(width: 10),
                                                  Text("กำลังบันทึกข้อมูล")
                                                ],
                                              ),
                                            ),
                                          );
                                        });

                                    print(
                                        "${_mobileAppPaymentIntResponse.price} ${_mobileAppPaymentIntResponse.remark}");

                                    String fileName =
                                        "${widget.branchNameAndPawnId}_${AppFormatters.formatDateAll.format(DateTime.now())}";
                                    Reference storageRef = _storage
                                        .ref()
                                        .child(AppFormatters.formatDateYYYY
                                            .format(DateTime.now()))
                                        .child("ddrangsit2_app")
                                        .child(fileName);

                                    UploadTask uploadTask;

                                    // สำหรับเว็บ ใช้ putData(), สำหรับ Android/iOS ใช้ putFile()
                                    if (kIsWeb) {
                                      uploadTask = storageRef.putData(
                                        _imageFile!,
                                        SettableMetadata(
                                            contentType: 'image/jpeg'),
                                      );
                                    } else {
                                      uploadTask = storageRef.putFile(
                                          _imageFile!); // ใช้ File สำหรับ Android/iOS
                                    }

                                    uploadTask.snapshotEvents.listen(
                                        (TaskSnapshot snapshot) {
                                      print(
                                          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
                                    }, onError: (e) {
                                      print('Error during upload: $e');
                                    });

                                    TaskSnapshot taskSnapshot =
                                        await uploadTask;
                                    print("Upload completed");

                                    if (taskSnapshot.state ==
                                        TaskState.success) {
                                      String downloadURL =
                                          await storageRef.getDownloadURL();
                                      print("Download URL: $downloadURL");

                                      print("upload data api");

                                      Map<String, String> headers = {
                                        "Accept": "application/json",
                                        "content-type": "application/json",
                                        'serverId': AppVariables.ServerId,
                                        'customerId': AppVariables.CustomerId
                                      };

                                      var requestBody = jsonEncode({
                                        "branchName": AppVariables
                                            .MobileAppPaymentIntBranchName,
                                        "type": AppVariables
                                            .MobileAppPaymentIntType,
                                        "status": "รออนุมัติ",
                                        "custId": AppVariables
                                            .MobileAppPaymentIntCustId,
                                        "custName": AppVariables.CUSTNAME,
                                        "billId": AppVariables
                                            .MobileAppPaymentIntBillId,
                                        "picLink": downloadURL,
                                        "price": _mobileAppPaymentIntResponse
                                            .price
                                            .toString(),
                                        "remark":
                                            _mobileAppPaymentIntResponse.remark,
                                        "tranBank": "",
                                        "tranBankAccNo": "",
                                        "dateTran": AppFormatters
                                            .formatDateToDatabase
                                            .format(selectedDate),
                                        "timeTran": _mobileAppPaymentIntResponse
                                            .timeTran,
                                        "dayPay": "0",
                                        "monthPay": _counterValue.toString(),
                                      });

                                      final response = await http.post(
                                        Uri.parse(
                                            "${AppVariables.API}/AddMobileAppPaymentInt"),
                                        headers: headers,
                                        body: requestBody,
                                      );

                                      statusCode = response.statusCode;
                                      print(
                                          "statuscode ${statusCode.toString()}");

                                      Navigator.pop(
                                          context); //ปิด dialog กำลังบันทึกข้อมูล

                                      if (statusCode == 204) {
                                        showDialogUploadComplete(context);

                                        //sendnoti
                                        Map<String, String> headersSendnoti = {
                                          "Accept": "application/json",
                                          "content-type": "application/json",
                                          'serverId': AppVariables.ServerId,
                                          'customerId': AppVariables.CustomerId,
                                          'onesignalappid':
                                              AppConstant.OneSignalAppId,
                                          'onesignalrestkey':
                                              AppConstant.OneSignalRestkey
                                        };

                                        final responseSendnoti = await http.put(
                                            Uri.parse(
                                                "${AppVariables.API}/AddMobileAppNotiSent?BranchName=${AppVariables.MobileAppPaymentIntBranchName}&NotiTitle=ต่อดอก&NotiRefNo=${AppVariables.MobileAppPaymentIntBillId}&NotiDetail=รออนุมัติ ยอดเงิน ${AppFormatters.formatNumber.format(_mobileAppPaymentIntResponse.price)} บาท&CustTel=${AppVariables.CUSTTEL}"),
                                            headers: headersSendnoti);

                                        print(
                                            "AddMobileAppPaymentInt complete");
                                        _formKey.currentState!.reset();
                                        setState(() {
                                          _imageFile = null;
                                          _counterValue = 1;
                                          amountPay.text = AppFormatters
                                              .formatNumber
                                              .format(double.parse(AppVariables
                                                              .IntPerMonth
                                                          .toString()
                                                      .replaceAll(",", "")) *
                                                  _counterValue);
                                        });
                                      } else {
                                        showDialogNotUpload(context);
                                        print(
                                            "Failed AddMobileAppPaymentInt data api ${statusCode}");
                                      }
                                    }
                                  } catch (_) {
                                    showDialogNotUpload(context);
                                    print("${_}");
                                  }
                                }
                              }
                            }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getFromGallery() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          // อ่านข้อมูลเป็น Uint8List สำหรับเว็บ
          Uint8List imageBytes = await pickedFile.readAsBytes();
          setState(() {
            _imageFile = imageBytes;
          });
        } else {
          // สร้าง File สำหรับ Android/iOS
          File imageFile = File(pickedFile.path);
          setState(() {
            _imageFile = imageFile;
          });
        }
      }
    } catch (e) {
      print('Error occurred while picking image: $e');
      // แสดงข้อความ error ใน UI หรือแจ้งเตือนผู้ใช้ได้ตามต้องการ
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      if (kIsWeb) {
        // อ่านข้อมูลเป็น Uint8List สำหรับเว็บ
        Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = imageBytes;
        });
      } else {
        // สร้าง File สำหรับ Android/iOS
        File imageFile = File(pickedFile.path);
        setState(() {
          _imageFile = imageFile;
        });
      }
    }
  }

  void showDialogNotUpload(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'ไม่สามารถเพิ่มรูปได้กรุณาลองใหม่อีกครั้ง',
            style: TextStyle(color: Colors.red),
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

  void showDialogUploadComplete(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // title: Text(
          //   'แจ้งเข้าระบบเรียบร้อยแล้วค่ะ 😊',
          //   style: TextStyle(color: AppVariables.FONT_COLOR_MENU),
          // ),
          content: Container(
            height: 250,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/paymentsuccess.png",
                  height: 250,
                  width: 250,
                ),
                // Text(
                //   "กรุณารออัพเดทจากทางร้าน ภายใน 24 ชั่วโมง",
                //   style: TextStyle(
                //       fontSize: 15,
                //       height: 1.2,
                //       color: AppVariables.FONT_COLOR_MENU),
                // ),
              ],
            ),
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
                Navigator.of(dialogContext).pop(true); // Dismiss alert dialo
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogCantCopy(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "❗️ไม่สามารถคัดลอกเลขที่บัญชีได้" +
                "\n" +
                "\n" +
                "\n" +
                "\n" +
                "",
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 28,
                  height: 1,
                  color: AppConstant.FONT_COLOR_MENU,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Dismiss alert dialo
              },
            ),
          ],
        );
      },
    );
  }
}
