import 'dart:convert';

import 'package:kanjanapisek_app/src/models/intredeem_response.dart';
import 'package:kanjanapisek_app/src/pages/uploadslipint_page.dart';
import 'package:kanjanapisek_app/src/utils/banknameandimage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:kanjanapisek_app/src/models/pawn_response.dart';
import 'package:kanjanapisek_app/src/services/app_service.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:kanjanapisek_app/src/utils/appcontroller.dart';
import 'package:kanjanapisek_app/src/utils/appformatters.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';

class PawnDtPage extends StatefulWidget {
  final PawnResponse pawnMt;

  PawnDtPage(this.pawnMt);

  @override
  _PawnDtPageState createState() => _PawnDtPageState();
}

class _PawnDtPageState extends State<PawnDtPage> {
  var amountGet = 0;

  void initState() {
    super.initState();
    AppVariables.PawnId = widget.pawnMt.pawnId!;
    AppVariables.PawnBranch = widget.pawnMt.branchName!;
    AppService().pawnDt();
  }

  Future<void> getIntPerMonth(BuildContext context) async {
    try {
      print("getIntPerMonth");
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'serverId': AppVariables.ServerId,
        'customerId': AppVariables.CustomerId
      };
      final url =
          "${AppVariables.API}/Calculator/MinimumIntPerMonth?branchname=${AppVariables.MobileAppPaymentIntBranchName}&IntPerMonth=${AppVariables.IntPerMonth}";
      final response = await http.get(Uri.parse(url), headers: requestHeaders);
      print(url);
      print("IntRedeemResponse : ${url}");
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final IntRedeemResponse intRedeemResponse =
            IntRedeemResponse.fromJson(json.decode(response.body));
        AppVariables.IntPerMonth =
            AppFormatters.formatNumber2.format(intRedeemResponse.intCal);
        print("IntRedeemResponse Complete");

        print(AppVariables.OverDayInt.toString());
        if (widget.pawnMt.duedate!
            .add(Duration(days: 16))
            // .add( Duration(days:1))
            .isAfter(DateTime.now())) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadSlipIntPage("Pawn-${widget.pawnMt.branchName}-${widget.pawnMt.pawnId}"),
              ));
        } else {
          showDialogDueDateOver(context);
        }
      }
    } catch (_) {
      print("${_}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(appController.pawnDts);
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg-home2.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  "ขายฝาก เลขที่ ${widget.pawnMt.pawnId}",
                  style: TextStyle(color: AppConstant.PRIMARY_COLOR),
                ),
                iconTheme: IconThemeData(
                  color: AppConstant.PRIMARY_COLOR,
                ),
                backgroundColor: Colors.white,
              ),
              body: ListView(
                children: [
                  pawnMt(),
                  pawnDescription(),
                  pawnDt(appController, context)
                ],
              ),
            ),
          );
        });
  }

  Container pawnDt(AppController appController, BuildContext context) {
    return Container(
        child: appController.pawnDts.isEmpty
            ? Center(
                child: Text(
                  "ไม่พบข้อมูลชำระดอกเบี้ย",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22),
                ),
              )
            : Column(
                children: [
                  Container(
                    color: Colors.grey.shade300,
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.width * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text("  รายการบัญชีออมทอง",
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 22),
                            textScaleFactor: 1),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: appController.pawnDts.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: Container(
                          color: Colors.grey.shade100,
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.width * 0.19,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "  ${AppFormatters.formatDate.format((appController.pawnDts[index].payDate!))}",
                                    style: TextStyle(fontSize: 22),
                                    textScaleFactor: 1,
                                  ),
                                  Text(
                                    "${AppFormatters.formatNumber.format((appController.pawnDts[index].amountPay))}  ",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                    textScaleFactor: 1,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "  ${AppFormatters.formatNumber.format((appController.pawnDts[index].monthPay))} เดือน ต่อดอกถึง ${AppFormatters.formatDate.format((appController.pawnDts[index].dueDate!))}",
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.grey),
                                    textScaleFactor: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ));
  }

  Container pawnDescription() {
    return Container(
      color: Colors.grey.shade100,
      width: MediaQuery.of(context).size.width * 1,
       height: MediaQuery.of(context).size.width * 0.54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text("  สาขาที่ทำรายการ : ${widget.pawnMt.branchName}",
              style: TextStyle(color: Colors.black, fontSize: 22),
              textScaleFactor: 1),
          Text("  สินค้า : ${widget.pawnMt.sumDescription}",
              style: TextStyle(color: Colors.black, fontSize: 22),
              textScaleFactor: 1),
          Text("  จำนวนรวม : ${widget.pawnMt.sumItemQty} ชิ้น",
              style: TextStyle(color: Colors.black, fontSize: 22),
              textScaleFactor: 1),
          Text("  น้ำหนักรวม : ${widget.pawnMt.sumItemwt} กรัม",
              style: TextStyle(color: Colors.black, fontSize: 22),
              textScaleFactor: 1),
          Text(
              "  วันที่ขายฝาก : ${AppFormatters.formatDate.format(widget.pawnMt.inDate!)}",
              style: TextStyle(color: Colors.black, fontSize: 22),
              textScaleFactor: 1),
          Text(
              "  วันที่ครบกำหนด : ${AppFormatters.formatDate.format(widget.pawnMt.duedate!)}",
              style: TextStyle(color: Colors.black, fontSize: 22),
              textScaleFactor: 1),
//ปิดปุ่มต่อดอกจากตรงนี้---------------
          //      Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     SizedBox(width: 10),
          //     // ElevatedButton(
          //     //   style: ButtonStyle(
          //     //       backgroundColor: WidgetStateProperty.all(
          //     //     Color(0xFF9900000),
          //     //   )),
          //     //   onPressed: () {
          //     //     AppVariables.MobileAppPaymentIntBranchName = widget.pawnMt.branchName!;
          //     //     AppVariables.MobileAppPaymentIntCustId = AppVariables.CUSTID;
          //     //     AppVariables.MobileAppPaymentIntType = "ลดเงินต้น";
          //     //     AppVariables.MobileAppPaymentIntBillId = widget.pawnMt.pawnId!;
          //     //     AppVariables.IntPerMonth = AppFormatters.formatNumber2.format(widget.pawnMt.intpay);
          //     //     AppVariables.Amountget = AppFormatters.formatNumber2.format(widget.pawnMt.amountget);
          //     //     AppVariables.BankAccInt = getBankName(widget.pawnMt.mobileTranBankInt);
          //     //     // if (widget.pawnMt.duedate!
          //     //     //     .add(Duration(days: AppVariables.OverDayInt))
          //     //     //     // .add( Duration(days:1))
          //     //     //     .isAfter(DateTime.now())) {
          //     //     //   checkWaitingApprovalMobileAppPaymentIntReduce(
          //     //     //       widget.pawnMt.pawnId!,
          //     //     //       widget.pawnMt.branchName!,
          //     //     //       context);
          //     //     // } else {
          //     //     //   showDialogDueDateOver(context);
          //     //     // }
          //     //     Navigator.push(
          //     //         context,
          //     //         MaterialPageRoute(
          //     //           builder: (context) =>
          //     //               UploadSlipIntReducePage("Reduce-${widget.pawnMt.branchName}-${widget.pawnMt.pawnId}"),
          //     //         ));
          //     //   },
          //     //   child: Row(
          //     //     children: [
          //     //       Icon(
          //     //         Icons.remove_circle,
          //     //         color: Colors.white,
          //     //       ),
          //     //       Text(
          //     //         "ลดเงินต้น",
          //     //         style: TextStyle(
          //     //           fontSize: 18,
          //     //           color: Colors.white,
          //     //         ),
          //     //       ),
          //     //     ],
          //     //   ),
          //     // ),
          //     SizedBox(width: 5),
          //     ElevatedButton(
          //       style: ButtonStyle(
          //           backgroundColor: WidgetStateProperty.all(
          //         Color(0xFF9900000),
          //       )),
          //       onPressed: () {
          //         AppVariables.MobileAppPaymentIntBranchName = widget.pawnMt.branchName!;
          //         AppVariables.MobileAppPaymentIntCustId = AppVariables.CUSTID;
          //         AppVariables.MobileAppPaymentIntType = "ต่อดอก";
          //         AppVariables.MobileAppPaymentIntBillId = widget.pawnMt.pawnId!;
          //         AppVariables.IntPerMonth = AppFormatters.formatNumber2.format(widget.pawnMt.intpay);
          //         AppVariables.BankInt = widget.pawnMt.mobileTranBankInt!;
          //         AppVariables.BankAcctNameInt = widget.pawnMt.mobileTranBankAcctNameInt!;
          //         AppVariables.BankAcctNoInt = widget.pawnMt.mobileTranBankAcctNoInt!;
          //         AppVariables.Month = AppFormatters.formatNumber.format(widget.pawnMt.months);
          //         AppVariables.DueDate = AppFormatters.formatDate.format(widget.pawnMt.duedate!);

          //         AppVariables.BankAccInt = getBankName(widget.pawnMt.mobileTranBankInt);

          //         getIntPerMonth(context);

          //         // Navigator.push(
          //         //     context,
          //         //     MaterialPageRoute(
          //         //       builder: (context) =>
          //         //           UploadSlipIntPage("Pawn-${widget.pawnMt.branchName}-${widget.pawnMt.pawnId}"),
          //         //     ));
          //       },
          //       child: Row(
          //         children: [
          //           Icon(
          //             Icons.add_circle,
          //             color: Colors.white,
          //           ),
          //           Text(
          //             " จ่ายค่าธรรมเนียม",
          //             style: TextStyle(color: Colors.white, fontSize: 20),
          //           ),
          //         ],
          //       ),
          //     ),
          //     SizedBox(width: 5),
          //     // ElevatedButton(
          //     //   style: ButtonStyle(
          //     //       backgroundColor: WidgetStateProperty.all(
          //     //     Color(0xFF9900000),
          //     //   )),
          //     //   onPressed: () {
          //     //     AppVariables.MobileAppPaymentIntBranchName =
          //     //         widget.pawnMt.branchName!;
          //     //     AppVariables.MobileAppPaymentIntCustId = AppVariables.CUSTID;
          //     //     AppVariables.MobileAppPaymentIntType = "ลดเงินต้น";

          //     //     AppVariables.MobileAppPaymentIntBillId =
          //     //         widget.pawnMt.pawnId!;
          //     //     AppVariables.Amountget = AppFormatters.formatNumber2
          //     //         .format(widget.pawnMt.amountget);
          //     //     AppVariables.IntPerMonth =
          //     //         AppFormatters.formatNumber2.format(widget.pawnMt.intpay);
          //     //     AppVariables.IntCal = 0;
          //     //     Navigator.push(
          //     //         context,
          //     //         MaterialPageRoute(
          //     //           builder: (context) => UploadSlipInt2Page(
          //     //               "Pawn-${widget.pawnMt.branchName}-${widget.pawnMt.pawnId}"),
          //     //         ));
          //     //   },
          //     //   child: Text(
          //     //     "แนบสลิป ลดต้น",
          //     //     style: TextStyle(color: Colors.white, fontSize: 20),
          //     //   ),
          //     // ),
          //     SizedBox(width: 5)
          //   ],
          // ),
          // //ปิดปุ่มต่อดอกถึงตรงนี้---------------
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Container pawnMt() {
    return Container(
      color: Colors.grey.shade300,
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.width * 0.35,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text("   เลขที่ขายฝาก",
                    style: TextStyle(color: Colors.grey, fontSize: 22),
                    textScaleFactor: 1),
                SizedBox(height: 10),
                Text("   ${widget.pawnMt.pawnId}",
                    style: TextStyle(color: Colors.grey, fontSize: 22),
                    textScaleFactor: 1),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        "${AppFormatters.formatNumber.format(widget.pawnMt.amountget)}",
                        style: TextStyle(color: Colors.black, fontSize: 30),
                        textScaleFactor: 1),
                    SizedBox(width: 20),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showDialogWaiting(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        content: Container(
          height: 200,
          child: Column(
            children: [
              Image.asset(
                "assets/images/waiting.png",
                height: 200,
                width: 250,
              ),
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
              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
            },
          ),
        ],
      );
    },
  );
}

void showDialogDueDateOver(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          "❗️รายการเกินกำหนด" + "\n" + "\n" + "กรุณาติดต่อหน้าร้านโดยตรง",
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

