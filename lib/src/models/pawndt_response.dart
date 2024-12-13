// To parse this JSON data, do
//
//     final pawnDtResponse = pawnDtResponseFromJson(jsonString);

import 'dart:convert';

List<PawnDtResponse> pawnDtResponseFromJson(String str) =>
    List<PawnDtResponse>.from(
        json.decode(str).map((x) => PawnDtResponse.fromJson(x)));

String pawnDtResponseToJson(List<PawnDtResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PawnDtResponse {
  String? pawnId;
  String? branchName;
  double? amountPay;
  DateTime? dueDate;
  DateTime? payDate;
  int? autoNo;
  int? dayPay;
  int? monthPay;
  String? prTime;
  String? paymentType;
  String? prid;
  String? tranBank;
  String? tranBankAccNo;
  String? custName;

  PawnDtResponse({
    this.pawnId,
    this.branchName,
    this.amountPay,
    this.dueDate,
    this.payDate,
    this.autoNo,
    this.dayPay,
    this.monthPay,
    this.prTime,
    this.paymentType,
    this.prid,
    this.tranBank,
    this.tranBankAccNo,
    this.custName,
  });

  factory PawnDtResponse.fromJson(Map<String, dynamic> json) => PawnDtResponse(
        pawnId: json["pawnId"],
        branchName: json["branchName"],
        amountPay: json["amountPay"]?.toDouble(),
        dueDate:
            json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
        payDate:
            json["payDate"] == null ? null : DateTime.parse(json["payDate"]),
        autoNo: json["autoNo"],
        dayPay: json["dayPay"],
        monthPay: json["monthPay"],
        prTime: json["prTime"],
        paymentType: json["paymentType"],
        prid: json["prid"],
        tranBank: json["tranBank"],
        tranBankAccNo: json["tranBankAccNo"],
        custName: json["custName"],
      );

  Map<String, dynamic> toJson() => {
        "pawnId": pawnId,
        "branchName": branchName,
        "amountPay": amountPay,
        "dueDate": dueDate?.toIso8601String(),
        "payDate": payDate?.toIso8601String(),
        "autoNo": autoNo,
        "dayPay": dayPay,
        "monthPay": monthPay,
        "prTime": prTime,
        "paymentType": paymentType,
        "prid": prid,
        "tranBank": tranBank,
        "tranBankAccNo": tranBankAccNo,
        "custName": custName,
      };
}
