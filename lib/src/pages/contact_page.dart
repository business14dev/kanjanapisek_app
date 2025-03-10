import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kanjanapisek_app/src/utils/appconstants.dart';

class ContactPage extends StatelessWidget {
  final List<Map<String, dynamic>> branches = [
    {
      'name': 'สาขา หน้าเมือง1 - ข้างตลาดสดบางลำภู',
      'numbers': '043322904',
    },
    {
      'name': 'สาขา หน้าเมือง2 - เยื้องแฟรี่พลาซ่า',
     'numbers': '043322914',
    },
    {
      'name': 'สาขา หนองเรือ',
      'numbers': '043294345',
    },
    {
      'name': 'สาขา ดอนโมง',
      'numbers': '043299599',
    },
    
  ];

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Cannot make a phone call to $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg-home2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ติดต่อสาขา",
                    style: TextStyle(color: AppConstant.PRIMARY_COLOR),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
            iconTheme: IconThemeData(
              color: AppConstant.PRIMARY_COLOR,
            ),
            backgroundColor: Colors.white),
        body: ListView.builder(
          itemCount: branches.length,
          itemBuilder: (context, index) {
            final branch = branches[index];
            return Column(
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // _showPhoneNumbersDialog(context, branch['name'], branch['numbers']);
                          _makePhoneCall(branch['numbers']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              color: AppConstant.PRIMARY_COLOR,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    branch['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppConstant.PRIMARY_COLOR,
                                    ),
                                  ),
                                    Text(
                                    branch['numbers'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppConstant.PRIMARY_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16, color: AppConstant.PRIMARY_COLOR),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey, // สีของเส้น
                  thickness: 1.0, // ความหนาของเส้น
                  indent: 16, // ระยะห่างจากด้านซ้าย
                  endIndent: 16, // ระยะห่างจากด้านขวา
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ContactPage(),
  ));
}
