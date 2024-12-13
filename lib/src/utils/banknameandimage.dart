String getBankName(String? bankCode) {
  switch (bankCode) {
    case "BAY":
      return "กรุงศรีอยุธยา";
    case "BAAC":
      return "ธ.ก.ส";
    case "BBL":
      return "กรุงเทพ";
    case "CIMBT":
      return "ซีไอเอ็มบี ไทย";
    case "GSB":
      return "ออมสิน";
    case "ICBS":
      return "ไอซีบีซี (ไทย)";
    case "KBANK":
      return "กสิกรไทย";
    case "KK":
      return "เกียรตินาคินภัทร";
    case "KTB":
      return "กรุงไทย";
    case "LH":
      return "แลนด์ แอนด์ เฮ้าส์";
    case "SCB":
      return "ไทยพาณิชย์";
    case "TISCO":
      return "ทิสโก้";
    case "TTB":
      return "ทหารไทยธนชาต";
    case "UOB":
      return "ยูโอบี";
    default:
      return "";
  }
}

String getBankImage(String? bankName) {
  switch (bankName) {
    case "กรุงศรีอยุธยา":
      return "assets/images/bank-bay.png";
    case "ธ.ก.ส":
      return "assets/images/bank-baac.png";
    case "กรุงเทพ":
      return "assets/images/bank-bbl.png";
    case "ซีไอเอ็มบี ไทย":
      return "assets/images/bank-cimbt.png";
    case "ออมสิน":
      return "assets/images/bank-gsb.png";
    case "ไอซีบีซี (ไทย)":
      return "assets/images/bank-icbc.png";
    case "กสิกรไทย":
      return "assets/images/bank-kbank.png";
    case "เกียรตินาคินภัทร":
      return "assets/images/bank-kk.png";
    case "กรุงไทย":
      return "assets/images/bank-ktb.png";
    case "แลนด์ แอนด์ เฮ้าส์":
      return "assets/images/bank-lh.png";
    case "ไทยพาณิชย์":
      return "assets/images/bank-scb.png";
    case "ทิสโก้":
      return "assets/images/bank-tisco.png";
    case "ทหารไทยธนชาต":
      return "assets/images/bank-ttb.png";
    case "ยูโอบี":
      return "assets/images/bank-uob.png";
    case "พร้อมเพย์":
      return "assets/images/promptpay.png";
    default:
      return "";
  }
}
