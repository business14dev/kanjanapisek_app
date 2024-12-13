// To parse this JSON data, do
//
//     final mobileAppPaymentIntResponse = mobileAppPaymentIntResponseFromJson(jsonString);

import 'dart:convert';

List<MobileAppPaymentIntResponse> mobileAppPaymentIntResponseFromJson(
        String str) =>
    List<MobileAppPaymentIntResponse>.from(
        json.decode(str).map((x) => MobileAppPaymentIntResponse.fromJson(x)));

String mobileAppPaymentIntResponseToJson(
        List<MobileAppPaymentIntResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MobileAppPaymentIntResponse {
  MobileAppPaymentIntResponse({
    this.autoNo,
    this.branchName,
    this.type,
    this.status,
    this.custId,
    this.dateSend,
    this.timeSend,
    this.billId,
    this.picLink,
    this.price,
    this.remark,
    this.tranBank,
    this.tranBankAccNo,
    this.dateTran,
    this.timeTran,
    this.dayPay,
    this.monthPay,
    this.amountGetReduce,
  });

  int? autoNo;
  String? branchName;
  String? type;
  String? status;
  String? custId;
  DateTime? dateSend;
  String? timeSend;
  String? billId;
  String? picLink;
  double? price;
  String? remark;
  String? tranBank;
  String? tranBankAccNo;
  DateTime? dateTran;
  String? timeTran;
  int? dayPay;
  int? monthPay;
  double? amountGetReduce;

  factory MobileAppPaymentIntResponse.fromJson(Map<String, dynamic> json) =>
      MobileAppPaymentIntResponse(
        autoNo: json["autoNo"] == null ? null : json["autoNo"],
        branchName: json["branchName"] == null ? null : json["branchName"],
        type: json["type"] == null ? null : json["type"],
        status: json["status"] == null ? null : json["status"],
        custId: json["custId"] == null ? null : json["custId"],
        dateSend:
            json["dateSend"] == null ? null : DateTime.parse(json["dateSend"]),
        timeSend: json["timeSend"] == null ? null : json["timeSend"],
        billId: json["billId"] == null ? null : json["billId"],
        picLink: json["picLink"] == null ? null : json["picLink"],
        price: json["price"] == null ? 0 : json["price"].toDouble(),
        remark: json["remark"] == null ? null : json["remark"],
        tranBank: json["tranBank"] == null ? null : json["tranBank"],
        tranBankAccNo:
            json["tranBankAccNo"] == null ? null : json["tranBankAccNo"],
        dateTran:
            json["dateTran"] == null ? null : DateTime.parse(json["dateTran"]),
        timeTran: json["timeTran"] == null ? null : json["timeTran"],
        monthPay: json["monthPay"] == null ? 0 : json["monthPay"],
        dayPay: json["dayPay"] == null ? 0 : json["dayPay"],
        amountGetReduce:
            json["amountGetReduce"] == null ? 0 : json["amountGetReduce"],
      );

  Map<String, dynamic> toJson() => {
        "autoNo": autoNo == null ? null : autoNo,
        "branchName": branchName == null ? null : branchName,
        "type": type == null ? null : type,
        "status": status == null ? null : status,
        "custId": custId == null ? null : custId,
        "dateSend": dateSend == null ? null : dateSend?.toIso8601String(),
        "timeSend": timeSend == null ? null : timeSend,
        "billId": billId == null ? null : billId,
        "picLink": picLink == null ? null : picLink,
        "price": price == null ? 0 : price,
        "remark": remark == null ? null : remark,
        "tranBank": tranBank == null ? null : tranBank,
        "tranBankAccNo": tranBankAccNo == null ? null : tranBankAccNo,
        "dateTran": dateTran == null ? null : dateTran?.toIso8601String(),
        "timeTran": timeTran == null ? null : timeTran,
        "monthPay": monthPay == null ? 0 : monthPay,
        "dayPay": dayPay == null ? 0 : dayPay,
        "amountGetReduce": dayPay == null ? 0 : dayPay,
      };
}
