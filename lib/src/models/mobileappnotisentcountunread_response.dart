// To parse this JSON data, do
//
//     final mobileAppNotiSentCountUnreadResponse = mobileAppNotiSentCountUnreadResponseFromJson(jsonString);

import 'dart:convert';

MobileAppNotiSentCountUnreadResponse
    mobileAppNotiSentCountUnreadResponseFromJson(String str) =>
        MobileAppNotiSentCountUnreadResponse.fromJson(json.decode(str));

String mobileAppNotiSentCountUnreadResponseToJson(
        MobileAppNotiSentCountUnreadResponse data) =>
    json.encode(data.toJson());

class MobileAppNotiSentCountUnreadResponse {
  MobileAppNotiSentCountUnreadResponse({
    this.custTel,
    this.countUnread,
  });

  String? custTel;
  int? countUnread;

  factory MobileAppNotiSentCountUnreadResponse.fromJson(
          Map<String, dynamic> json) =>
      MobileAppNotiSentCountUnreadResponse(
        custTel: json["custTel"] == null ? null : json["custTel"],
        countUnread: json["countUnread"] == null ? null : json["countUnread"],
      );

  Map<String, dynamic> toJson() => {
        "custTel": custTel == null ? null : custTel,
        "countUnread": countUnread == null ? null : countUnread,
      };
}
