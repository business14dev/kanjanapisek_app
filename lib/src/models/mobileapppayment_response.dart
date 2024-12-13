// To parse this JSON data, do
//
//     final mobileAppPaymentResponse = mobileAppPaymentResponseFromJson(jsonString);

import 'dart:convert';

List<MobileAppPaymentResponse> mobileAppPaymentResponseFromJson(String str) =>
    List<MobileAppPaymentResponse>.from(
        json.decode(str).map((x) => MobileAppPaymentResponse.fromJson(x)));

String mobileAppPaymentResponseToJson(List<MobileAppPaymentResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MobileAppPaymentResponse {
  MobileAppPaymentResponse({
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
    this.remarkApprove,
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
  String? remarkApprove;

  factory MobileAppPaymentResponse.fromJson(Map<String, dynamic> json) =>
      MobileAppPaymentResponse(
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
        price: json["price"] == null ? null : json["price"].toDouble(),
        remark: json["remark"] == null ? null : json["remark"],
        tranBank: json["tranBank"] == null ? null : json["tranBank"],
        tranBankAccNo:
            json["tranBankAccNo"] == null ? null : json["tranBankAccNo"],
        dateTran:
            json["dateTran"] == null ? null : DateTime.parse(json["dateTran"]),
        timeTran: json["timeTran"] == null ? null : json["timeTran"],
        remarkApprove:
            json["remarkApprove"] == null ? null : json["remarkApprove"],
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
        "price": price == null ? null : price,
        "remark": remark == null ? null : remark,
        "tranBank": tranBank == null ? null : tranBank,
        "tranBankAccNo": tranBankAccNo == null ? null : tranBankAccNo,
        "dateTran": dateTran == null ? null : dateTran?.toIso8601String(),
        "timeTran": timeTran == null ? null : timeTran,
        "remarkApprove": remarkApprove == null ? null : remarkApprove,
      };
}
