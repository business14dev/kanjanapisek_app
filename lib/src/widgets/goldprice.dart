import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kanjanapisek_app/src/utils/appvariables.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

Future<bool> fetchGoldPrice() async {
  try {
    String GoldPrice = "";

    final url = "https://apiconfigservice-b2drcpbnehb5fubc.southeastasia-01.azurewebsites.net/GoldPrice";
    print(url);
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // final List<GoldPriceResponse> goldPriceResponse =
      //     List<GoldPriceResponse>.from(
      //         goldPriceResponseFromJson(response.body));
      // print("fetchGoldPrice Complete");
      // // return goldPriceResponse;
      // Constant.GoldPrice =
      //     "${Constant.formatNumber.format(double.parse(goldPriceResponse[4].bid))} - ${Constant.formatNumber.format(double.parse(goldPriceResponse[4].ask))} ";
      // // Constant.GoldPrice = "${goldPriceResponse[4].name}";

      GoldPrice = response.body;
      if (GoldPrice.length > 0) {
        final SplitValue = GoldPrice.split("|");

        if (SplitValue.length > 0) {
          AppVariables.GoldPrice = "${SplitValue[1]} - ${SplitValue[0]}";
          AppVariables.GoldPriceSale = SplitValue[0];
          AppVariables.GoldPriceBuy = SplitValue[1];
          AppVariables.GoldPriceText = SplitValue[4];
          AppVariables.GoldPriceUpDown = SplitValue[5];
        }
      }

      print(AppVariables.GoldPrice);
      return true;
    }
    print('Network failed GoldPriceService');
    return false;
  } catch (_) {
    print("${_}");
    return false;
  }
}

class BuildGoldPrice extends StatefulWidget {
  @override
  _BuildGoldPriceState createState() => _BuildGoldPriceState();
}

class _BuildGoldPriceState extends State<BuildGoldPrice> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse("https://www.goldtraders.or.th/")),
      child: Container(
        child: FutureBuilder(
            future: fetchGoldPrice(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == true) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(" ราคาทองแท่ง  ${AppVariables.GoldPrice}",
                              style: TextStyle(
                                  fontSize: 18, color: AppConstant.FONT_COLOR)),
                          SizedBox(
                            width: 10,
                          ),
                          int.parse(AppVariables.GoldPriceUpDown) > 0
                              ? Icon(
                                  Icons.arrow_upward,
                                  size: 18,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.arrow_downward,
                                  size: 18,
                                  color: Colors.red,
                                ),
                          int.parse(AppVariables.GoldPriceUpDown) > 0
                              ? Text(" ${AppVariables.GoldPriceUpDown}",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.green))
                              : Text(" ${AppVariables.GoldPriceUpDown}",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(" ประจำวันที่ ${AppVariables.GoldPriceText}",
                          style: TextStyle(
                              fontSize: 16, color: AppConstant.FONT_COLOR)),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
