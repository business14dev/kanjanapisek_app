// To parse this JSON data, do
//
//     final mobileAppRewardResponse = mobileAppRewardResponseFromJson(jsonString);

import 'dart:convert';

List<MobileAppRewardResponse> mobileAppRewardResponseFromJson(String str) =>
    List<MobileAppRewardResponse>.from(
        json.decode(str).map((x) => MobileAppRewardResponse.fromJson(x)));

String mobileAppRewardResponseToJson(List<MobileAppRewardResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MobileAppRewardResponse {
  String? mobileAppRewardId;
  String? mobileAppRewardName;
  String? mobileAppRewardDetail;
  String? mobileAppRewardLink;
  DateTime? mobileAppRewardDate;
  String? mobileAppRewardTime;
  int? autoNo;

  MobileAppRewardResponse({
    this.mobileAppRewardId,
    this.mobileAppRewardName,
    this.mobileAppRewardDetail,
    this.mobileAppRewardLink,
    this.mobileAppRewardDate,
    this.mobileAppRewardTime,
    this.autoNo,
  });

  factory MobileAppRewardResponse.fromJson(Map<String, dynamic> json) =>
      MobileAppRewardResponse(
        mobileAppRewardId: json["mobileAppRewardID"],
        mobileAppRewardName: json["mobileAppRewardName"],
        mobileAppRewardDetail: json["mobileAppRewardDetail"],
        mobileAppRewardLink: json["mobileAppRewardLink"],
        mobileAppRewardDate: json["mobileAppRewardDate"] == null
            ? null
            : DateTime.parse(json["mobileAppRewardDate"]),
        mobileAppRewardTime: json["mobileAppRewardTime"],
        autoNo: json["autoNo"],
      );

  Map<String, dynamic> toJson() => {
        "mobileAppRewardID": mobileAppRewardId,
        "mobileAppRewardName": mobileAppRewardName,
        "mobileAppRewardDetail": mobileAppRewardDetail,
        "mobileAppRewardLink": mobileAppRewardLink,
        "mobileAppRewardDate": mobileAppRewardDate?.toIso8601String(),
        "mobileAppRewardTime": mobileAppRewardTime,
        "autoNo": autoNo,
      };
}
