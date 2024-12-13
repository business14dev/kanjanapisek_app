import 'package:flutter/material.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: _buildLogo(),
      ),
    );
  }

  Container _buildLogo() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(50.0),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"))),
              ),
            ],
          ),
          // Text(
          //   "ห้างทองกาญจนาภิเษก",
          //   style: TextStyle(
          //     fontSize: 22,
          //     color: AppConstant.FONT_COLOR_MENU,
          //   ),
          // ),
        ],
      ),
    );
  }
}
