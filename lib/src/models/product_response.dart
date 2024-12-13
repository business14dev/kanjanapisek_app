import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductResponse {
  String mobileAppPromotionId;
  String mobileAppPromotionName;
  String mobileAppPromotionDetail;
  String mobileAppPromotionLink;
  DateTime mobileAppPromotionDate;
  String mobileAppPromotionTime;
  String mobileAppPromotionLinkWeb;
  int autoNo;
  String mobileAppPromotionCoverLink;
  String mobileAppPromotionType;
  String mobileAppPromotionSubMenu;

  ProductResponse({
    required this.mobileAppPromotionId,
    required this.mobileAppPromotionName,
    required this.mobileAppPromotionDetail,
    required this.mobileAppPromotionLink,
    required this.mobileAppPromotionDate,
    required this.mobileAppPromotionTime,
    required this.mobileAppPromotionLinkWeb,
    required this.autoNo,
    required this.mobileAppPromotionCoverLink,
    required this.mobileAppPromotionType,
    required this.mobileAppPromotionSubMenu,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mobileAppPromotionId': mobileAppPromotionId,
      'mobileAppPromotionName': mobileAppPromotionName,
      'mobileAppPromotionDetail': mobileAppPromotionDetail,
      'mobileAppPromotionLink': mobileAppPromotionLink,
      'mobileAppPromotionDate': mobileAppPromotionDate,
      'mobileAppPromotionTime': mobileAppPromotionTime,
      'mobileAppPromotionLinkWeb': mobileAppPromotionLinkWeb,
      'autoNo': autoNo,
      'mobileAppPromotionCoverLink': mobileAppPromotionCoverLink,
      'mobileAppPromotionType': mobileAppPromotionType,
      'mobileAppPromotionSubMenu': mobileAppPromotionSubMenu,
    };
  }

  factory ProductResponse.fromMap(Map<String, dynamic> map) {
    return ProductResponse(
      mobileAppPromotionId: (map['mobileAppPromotionId'] ?? '') as String,
      mobileAppPromotionName: (map['mobileAppPromotionName'] ?? '') as String,
      mobileAppPromotionDetail:
          (map['mobileAppPromotionDetail'] ?? '') as String,
      mobileAppPromotionLink: (map['mobileAppPromotionLink'] ?? '') as String,
      mobileAppPromotionDate: DateTime.parse(map["mobileAppPromotionDate"]),
      mobileAppPromotionTime: (map['mobileAppPromotionTime'] ?? '') as String,
      mobileAppPromotionLinkWeb:
          (map['mobileAppPromotionLinkWeb'] ?? '') as String,
      autoNo: (map['autoNo'] ?? 0) as int,
      mobileAppPromotionCoverLink:
          (map['mobileAppPromotionCoverLink'] ?? '') as String,
      mobileAppPromotionType: (map['mobileAppPromotionType'] ?? '') as String,
      mobileAppPromotionSubMenu:
          (map['mobileAppPromotionSubMenu'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductResponse.fromJson(String source) =>
      ProductResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
