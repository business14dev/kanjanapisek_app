// To parse this JSON data, do
//
//     final savingResponse = savingResponseFromJson(jsonString);

import 'dart:convert';

List<SavingResponse> savingResponseFromJson(String str) =>
    List<SavingResponse>.from(
        json.decode(str).map((x) => SavingResponse.fromJson(x)));

String savingResponseToJson(List<SavingResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SavingResponse {
  String? savingId;
  String? custId;
  String? custTel;
  String? custThaiId;
  String? custName;
  String? branchName;
  DateTime? savingDate;
  DateTime? savingDueDate;
  double? totalPrice;
  double? totalPay;
  double? totalRemain;
  String? sumDescription;
  double? sumItemwt;
  int? sumItemQty;
  String? empName;
  int? months;
  double? amountPay;
  DateTime? payDate;
  double? totalAmountPay;
  int? no;
  int? autoNo;
  String? prTime;
  double? moneyBackWard;
  String? paymentType;
  String? prid;
  String? tranBank;
  String? tranBankAccNo;

  SavingResponse({
    this.savingId,
    this.custId,
    this.custTel,
    this.custThaiId,
    this.custName,
    this.branchName,
    this.savingDate,
    this.savingDueDate,
    this.totalPrice,
    this.totalPay,
    this.totalRemain,
    this.sumDescription,
    this.sumItemwt,
    this.sumItemQty,
    this.empName,
    this.months,
    this.amountPay,
    this.payDate,
    this.totalAmountPay,
    this.no,
    this.autoNo,
    this.prTime,
    this.moneyBackWard,
    this.paymentType,
    this.prid,
    this.tranBank,
    this.tranBankAccNo,
  });

  factory SavingResponse.fromJson(Map<String, dynamic> json) => SavingResponse(
        savingId: json["savingId"],
        custId: json["custId"],
        custTel: json["custTel"],
        custThaiId: json["custThaiId"],
        custName: json["custName"],
        branchName: json["branchName"],
        savingDate: json["savingDate"] == null
            ? null
            : DateTime.parse(json["savingDate"]),
        savingDueDate: json["savingDueDate"] == null
            ? null
            : DateTime.parse(json["savingDueDate"]),
        totalPrice: json["totalPrice"]?.toDouble(),
        totalPay: json["totalPay"]?.toDouble(),
        totalRemain: json["totalRemain"]?.toDouble(),
        sumDescription: json["sumDescription"],
        sumItemwt: json["sumItemwt"]?.toDouble(),
        sumItemQty: json["sumItemQty"],
        empName: json["empName"],
        months: json["months"],
        amountPay: json["amountPay"]?.toDouble(),
        payDate:
            json["payDate"] == null ? null : DateTime.parse(json["payDate"]),
        totalAmountPay: json["totalAmountPay"]?.toDouble(),
        no: json["no"],
        autoNo: json["autoNo"],
        prTime: json["prTime"],
        moneyBackWard: json["moneyBackWard"]?.toDouble(),
        paymentType: json["paymentType"],
        prid: json["prid"],
        tranBank: json["tranBank"],
        tranBankAccNo: json["tranBankAccNo"],
      );

  Map<String, dynamic> toJson() => {
        "savingId": savingId,
        "custId": custId,
        "custTel": custTel,
        "custThaiId": custThaiId,
        "custName": custName,
        "branchName": branchName,
        "savingDate": savingDate?.toIso8601String(),
        "savingDueDate": savingDueDate?.toIso8601String(),
        "totalPrice": totalPrice,
        "totalPay": totalPay,
        "totalRemain": totalRemain,
        "sumDescription": sumDescription,
        "sumItemwt": sumItemwt,
        "sumItemQty": sumItemQty,
        "empName": empName,
        "months": months,
        "amountPay": amountPay,
        "payDate": payDate?.toIso8601String(),
        "totalAmountPay": totalAmountPay,
        "no": no,
        "autoNo": autoNo,
        "prTime": prTime,
        "moneyBackWard": moneyBackWard,
        "paymentType": paymentType,
        "prid": prid,
        "tranBank": tranBank,
        "tranBankAccNo": tranBankAccNo,
      };
}
