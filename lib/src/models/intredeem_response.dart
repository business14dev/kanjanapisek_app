// To parse this JSON data, do
//
//     final intRedeemResponse = intRedeemResponseFromJson(jsonString);

import 'dart:convert';

IntRedeemResponse intRedeemResponseFromJson(String str) =>
    IntRedeemResponse.fromJson(json.decode(str));

String intRedeemResponseToJson(IntRedeemResponse data) =>
    json.encode(data.toJson());

class IntRedeemResponse {
  int? monthCal;
  int? dayCal;
  double? intCal;
  DateTime? startDate;
  DateTime? endDate;

  IntRedeemResponse({
    this.monthCal,
    this.dayCal,
    this.intCal,
    this.startDate,
    this.endDate,
  });

  factory IntRedeemResponse.fromJson(Map<String, dynamic> json) =>
      IntRedeemResponse(
        monthCal: json["monthCal"],
        dayCal: json["dayCal"],
        intCal: json["intCal"].toDouble(),
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "monthCal": monthCal,
        "dayCal": dayCal,
        "intCal": intCal,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
      };
}
