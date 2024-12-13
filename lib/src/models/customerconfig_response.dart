// To parse this JSON data, do
//
//     final customerConfigResponse = customerConfigResponseFromJson(jsonString);

import 'dart:convert';

CustomerConfigResponse customerConfigResponseFromJson(String str) =>
    CustomerConfigResponse.fromJson(json.decode(str));

String customerConfigResponseToJson(CustomerConfigResponse data) =>
    json.encode(data.toJson());

class CustomerConfigResponse {
  String? custId;
  String? custName;
  String? contactName;
  String? custTel;
  String? serverIp;
  String? api;
  String? custType;
  int? autoNo;
  String? databaseName;
  String? custEmail;

  CustomerConfigResponse({
    this.custId,
    this.custName,
    this.contactName,
    this.custTel,
    this.serverIp,
    this.api,
    this.custType,
    this.autoNo,
    this.databaseName,
    this.custEmail,
  });

  factory CustomerConfigResponse.fromJson(Map<String, dynamic> json) =>
      CustomerConfigResponse(
        custId: json["custID"],
        custName: json["custName"],
        contactName: json["contactName"],
        custTel: json["custTel"],
        serverIp: json["serverIP"],
        api: json["api"],
        custType: json["custType"],
        autoNo: json["autoNo"],
        databaseName: json["databaseName"],
        custEmail: json["custEmail"],
      );

  Map<String, dynamic> toJson() => {
        "custID": custId,
        "custName": custName,
        "contactName": contactName,
        "custTel": custTel,
        "serverIP": serverIp,
        "api": api,
        "custType": custType,
        "autoNo": autoNo,
        "databaseName": databaseName,
        "custEmail": custEmail,
      };
}
