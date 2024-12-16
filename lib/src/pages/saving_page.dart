import 'package:kanjanapisek_app/src/pages/uploadslip_page.dart';
import 'package:kanjanapisek_app/src/utils/banknameandimage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kanjanapisek_app/src/models/savingmt_response.dart';
import 'package:kanjanapisek_app/src/services/app_service.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'package:kanjanapisek_app/src/utils/appcontroller.dart';
import 'package:kanjanapisek_app/src/utils/appformatters.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';

class SavingPage extends StatefulWidget {
  final SavingMtResponse savingMt;

  SavingPage(this.savingMt);

  @override
  _SavingPage createState() => _SavingPage();
}

class _SavingPage extends State<SavingPage> {
  void initState() {
    super.initState();
    AppVariables.SavingId = widget.savingMt.savingId!;
    AppService().savingDt();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(appController.savingMts);
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
                    title: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ออมทอง",
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 1.0,
                          ),
                        ],
                      ),
                    ),
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                    backgroundColor: Color(0xFF990000)),
                body: ListView(
                  children: [
                    savingMt(),
                    savingDescription(),
                    savingDt(appController, context),
                  ],
                )),
          );
        });
  }

  Widget savingDt(AppController appController, BuildContext context) {
    return Container(
      child: appController.savingDts.isEmpty
          ? SizedBox()
          : Column(
              children: [
                Container(
                  color: Colors.grey.shade300,
                  width: MediaQuery.of(context).size.width * 1,
                  height: 55,
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
                    itemCount: appController.savingDts.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {},
                      child: Container(
                        color: Colors.grey.shade100,
                        width: MediaQuery.of(context).size.width * 1,
                        height: 80,
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "  No.${(appController.savingDts[index].no)}",
                                  style: TextStyle(fontSize: 22),
                                  textScaleFactor: 1,
                                ),
                                Text(
                                  "+${AppFormatters.formatNumber.format((appController.savingDts[index].amountPay))}  ",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "  ${AppFormatters.formatDate.format((appController.savingDts[index].payDate!))}",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.grey),
                                  textScaleFactor: 1,
                                ),
                                Text(
                                  "${AppFormatters.formatNumber.format((appController.savingDts[index].totalAmountPay))}  ",
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
            ),
    );
  }

  Container savingDescription() {
    return Container(
      color: Colors.grey.shade100,
      width: MediaQuery.of(context).size.width * 1,
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text("  สาขาที่ทำรายการ : ${widget.savingMt.branchName}",
              style: TextStyle(color: Colors.black, fontSize: 22),
              textScaleFactor: 1),
          Text(
              "  วันที่เปิดออม : ${AppFormatters.formatDate.format(widget.savingMt.savingDate!)}",
              style: TextStyle(color: Colors.black, fontSize: 22),
              textScaleFactor: 1),
                Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                Color(0xFF9900000),
              )),
              onPressed: () {
                AppVariables.MobileAppPaymentBranchName = widget.savingMt.branchName!;
                AppVariables.MobileAppPaymentCustId = AppVariables.CUSTID;
                AppVariables.MobileAppPaymentType = "ออมทอง";
                AppVariables.MobileAppPaymentBillId = widget.savingMt.savingId!;
                AppVariables.BankAcctNameSaving = widget.savingMt.mobileTranBankAcctNameSaving!;
                AppVariables.BankAcctNoSaving = widget.savingMt.mobileTranBankAcctNoSaving!;
            
                AppVariables.BankAccSaving = getBankName(widget.savingMt.mobileTranBankSaving);
            
                // checkWaitingApprovalMobileAppPayment(widget.savingMt.savingId!, widget.savingMt.branchName!, context);
            
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadSlipPagePage("Saving-${widget.savingMt.savingId}"),
                    ));
              },
              child: Text(
                "เพิ่มเงินออม",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
       
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget savingMt() {
    return Container(
      color: Colors.grey.shade300,
      width: MediaQuery.of(context).size.width * 1,
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 145,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text("   เลขที่ออมทอง",
                    style: TextStyle(color: Colors.grey, fontSize: 22),
                    textScaleFactor: 1),
                SizedBox(height: 10),
                Text("   ${widget.savingMt.savingId!}",
                    style: TextStyle(color: Colors.grey, fontSize: 22),
                    textScaleFactor: 1),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        "${AppFormatters.formatNumber.format(widget.savingMt.totalPay)}",
                        style: TextStyle(color: Colors.black, fontSize: 30),
                        textScaleFactor: 1),
                    SizedBox(width: 20),
                  ],
                ),
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
