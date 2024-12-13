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
      'name': 'สสาขา หน้าเมือง2 - เยื้องแฟรี่พลาซ่า',
     'numbers': '043322914',
    },
    {
      'name': ' สาขา หนองเรือ',
      'numbers': '043294345',
    },
    {
      'name': '  สาขา ดอนโมง',
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

  void _showPhoneNumbersDialog(BuildContext context, String branchName, List<String> numbers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'เบอร์โทร $branchName',
            style: TextStyle(
              fontSize: 18, // ขนาดข้อความ
              color: Colors.blue, // สีข้อความ
              fontWeight: FontWeight.w500, // น้ำหนักข้อความ
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: numbers.map((number) {
              return ListTile(
                leading: Icon(Icons.phone, color: Colors.blue),
                title: Text(
                  number,
                  style: TextStyle(
                    fontSize: 18, // ขนาดข้อความ
                    color: Colors.blue, // สีข้อความ
                    fontWeight: FontWeight.w500, // น้ำหนักข้อความ
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(); // ปิด Dialog
                  _makePhoneCall(number);
                },
              );
            }).toList(),
          ),
        );
      },
    );
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
                              color: AppConstant.FONT_COLOR_MENU,
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
                                      color: AppConstant.FONT_COLOR_MENU,
                                    ),
                                  ),
                                    Text(
                                    branch['numbers'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppConstant.FONT_COLOR_MENU,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16, color: AppConstant.FONT_COLOR_MENU),
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
