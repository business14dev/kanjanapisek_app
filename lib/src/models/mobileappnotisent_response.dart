// To parse this JSON data, do
//
//     final mobileAppNotiSentResponse = mobileAppNotiSentResponseFromJson(jsonString);

import 'dart:convert';

List<MobileAppNotiSentResponse> mobileAppNotiSentResponseFromJson(String str) =>
    List<MobileAppNotiSentResponse>.from(
        json.decode(str).map((x) => MobileAppNotiSentResponse.fromJson(x)));

String mobileAppNotiSentResponseToJson(List<MobileAppNotiSentResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MobileAppNotiSentResponse {
  int? autoNo;
  String? branchName;
  DateTime? notiDate;
  String? notiTime;
  String? notiTitle;
  String? notiRefNo;
  String? notiDetail;
  String? custTel;
  bool? statusCheckNoti;

  MobileAppNotiSentResponse({
    this.autoNo,
    this.branchName,
    this.notiDate,
    this.notiTime,
    this.notiTitle,
    this.notiRefNo,
    this.notiDetail,
    this.custTel,
    this.statusCheckNoti,
  });

  factory MobileAppNotiSentResponse.fromJson(Map<String, dynamic> json) =>
      MobileAppNotiSentResponse(
        autoNo: json["autoNo"],
        branchName: json["branchName"],
        notiDate:
            json["notiDate"] == null ? null : DateTime.parse(json["notiDate"]),
        notiTime: json["notiTime"],
        notiTitle: json["notiTitle"],
        notiRefNo: json["notiRefNo"],
        notiDetail: json["notiDetail"],
        custTel: json["custTel"],
        statusCheckNoti: json["statusCheckNoti"],
      );

  Map<String, dynamic> toJson() => {
        "autoNo": autoNo,
        "branchName": branchName,
        "notiDate": notiDate?.toIso8601String(),
        "notiTime": notiTime,
        "notiTitle": notiTitle,
        "notiRefNo": notiRefNo,
        "notiDetail": notiDetail,
        "custTel": custTel,
        "statusCheckNoti": statusCheckNoti,
      };
}
