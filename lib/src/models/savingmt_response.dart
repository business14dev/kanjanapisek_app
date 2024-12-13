// To parse this JSON data, do
//
//     final savingMtResponse = savingMtResponseFromJson(jsonString);

import 'dart:convert';

List<SavingMtResponse> savingMtResponseFromJson(String str) =>
    List<SavingMtResponse>.from(
        json.decode(str).map((x) => SavingMtResponse.fromJson(x)));

String savingMtResponseToJson(List<SavingMtResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SavingMtResponse {
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
  int? autoNo;
  double? moneyBackWard;
  String? mobileTranBankSaving;
  String? mobileTranBankAcctNoSaving;
  String? mobileTranBankAcctNameSaving;
  String? agentName;

  SavingMtResponse({
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
    this.autoNo,
    this.moneyBackWard,
    this.mobileTranBankSaving,
    this.mobileTranBankAcctNoSaving,
    this.mobileTranBankAcctNameSaving,
    this.agentName,
  });

  factory SavingMtResponse.fromJson(Map<String, dynamic> json) =>
      SavingMtResponse(
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
        autoNo: json["autoNo"],
        moneyBackWard: json["moneyBackWard"]?.toDouble(),
        mobileTranBankSaving: json["mobileTranBankSaving"],
        mobileTranBankAcctNoSaving: json["mobileTranBankAcctNoSaving"],
        mobileTranBankAcctNameSaving: json["mobileTranBankAcctNameSaving"],
        agentName: json["agentName"],
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
        "autoNo": autoNo,
        "moneyBackWard": moneyBackWard,
        "mobileTranBankSaving": mobileTranBankSaving,
        "mobileTranBankAcctNoSaving": mobileTranBankAcctNoSaving,
        "mobileTranBankAcctNameSaving": mobileTranBankAcctNameSaving,
        "agentName": agentName,
      };
}
