import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanjanapisek_app/src/services/app_service.dart';
import 'package:kanjanapisek_app/src/utils/appcontroller.dart';

class ProductRecommendPage extends StatefulWidget {
  @override
  State<ProductRecommendPage> createState() => _ProductRecommendPageState();
}

class _ProductRecommendPageState extends State<ProductRecommendPage> {
  @override
  void initState() {
    super.initState();
    AppService().newProductP1();
  }

  Widget build(BuildContext context) {
    return GetX(
      init: AppController(),
      builder: (AppController appController) {
        //print(appController.promotionModels);
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg-home.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Color(0xFF990000),
                title: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                      Text(
                        'สินค้าแนะนำ',
                        style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                toolbarHeight: 90,
              ),
              body: ListView(
                children: [
                  Container(
                      child: appController.newProductP1s.isEmpty
                          ? SizedBox()
                          : Column(
                              children: [
                                SizedBox(
                                  child: GridView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        appController.newProductP1s.length,
                                    // itemCount: 6,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              1.5),
                                    ),
                                    itemBuilder: (context, index) => InkWell(
                                      // onTap: () {
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             TimeLineImagePage(
                                      //                 post: appController
                                      //                         .newProductP1s[
                                      //                     index]),
                                      //       ));
                                      // },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Image.network(
                                                  appController
                                                      .newProductP1s[index]
                                                      .mobileAppPromotionLink,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                ],
              )),
        );
      },
    );
  }
}
