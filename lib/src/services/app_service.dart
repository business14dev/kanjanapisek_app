import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kanjanapisek_app/src/models/mobileappnotisent_response.dart';
import 'package:kanjanapisek_app/src/models/mobileappreward_reponse.dart';
import 'package:kanjanapisek_app/src/models/pawn_response.dart';
import 'package:kanjanapisek_app/src/models/pawndt_response.dart';
import 'package:kanjanapisek_app/src/models/product_response.dart';
import 'package:kanjanapisek_app/src/models/saving_response.dart';
import 'package:kanjanapisek_app/src/models/savingmt_response.dart';
import 'package:kanjanapisek_app/src/utils/appvariables.dart';
import 'package:kanjanapisek_app/src/utils/appcontroller.dart';
import 'package:kanjanapisek_app/src/utils/appformatters.dart';

class AppService {
  AppController appController = Get.put(AppController());

  Future<void> promotionBannerP1() async {
    Map<String, dynamic> map = {};
    map['serverId'] = AppVariables.ServerId;
    map['customerId'] = AppVariables.CustomerId;

    print('### map---> $map');

    String urlAPI =
        '${AppVariables.API}/ViewAPIMAP?mobileAppPromotionType=โปรโมชั่น';

    print('### urlAPI ---> $urlAPI');

    await Dio().get(urlAPI, options: Options(headers: map)).then((value) {
      // print('#### valuve for proDuct -----> $value');

      appController.productModels.clear();
      for (var element in value.data) {
        ProductResponse productModel = ProductResponse.fromMap(element);
        appController.productModels.add(productModel);
      }
    });
  }

  Future<void> newProductP1() async {
    Map<String, dynamic> map = {};
    map['serverId'] = AppVariables.ServerId;
    map['customerId'] = AppVariables.CustomerId;

    print('### map---> $map');

    String urlAPI =
        '${AppVariables.API}/ViewAPIMAP?mobileAppPromotionType=สินค้าแนะนำ';

    print('### urlAPI ---> $urlAPI');

    await Dio().get(urlAPI, options: Options(headers: map)).then((value) {
      // print('#### valuve for proDuct -----> $value');

      appController.newProductP1s.clear();
      for (var element in value.data) {
        ProductResponse newProductP1 = ProductResponse.fromMap(element);
        appController.newProductP1s.add(newProductP1);
      }
    });
  }

  Future<void> promotionBannerP2() async {
    Map<String, dynamic> map = {};
    map['serverId'] = AppVariables.ServerId;
    map['customerId'] = AppVariables.CustomerId;

    print('### map---> $map');

    String urlAPI =
        '${AppVariables.API}/ViewAPIMAP?mobileAppPromotionType=โปรหน้า2';

    print('### urlAPI ---> $urlAPI');

    await Dio().get(urlAPI, options: Options(headers: map)).then((value) {
      // print('#### valuve for proDuct -----> $value');

      appController.newPromotionP2s.clear();
      for (var element in value.data) {
        ProductResponse newPromotionP2 = ProductResponse.fromMap(element);
        appController.newPromotionP2s.add(newPromotionP2);
      }
    });
  }

  Future<void> menuP2() async {
    Map<String, dynamic> map = {};
    map['serverId'] = AppVariables.ServerId;
    map['customerId'] = AppVariables.CustomerId;

    print('### map---> $map');

    String urlAPI =
        '${AppVariables.API}/ViewAPIMAP?mobileAppPromotionType=เมนูกลางหน้า2';

    print('### urlAPI ---> $urlAPI');

    await Dio().get(urlAPI, options: Options(headers: map)).then((value) {
      // print('#### valuve for proDuct -----> $value');

      appController.menuP2s.clear();
      for (var element in value.data) {
        ProductResponse menuP2 = ProductResponse.fromMap(element);
        appController.menuP2s.add(menuP2);
      }
    });
  }

  Future<void> productP2() async {
    Map<String, dynamic> map = {};
    map['serverId'] = AppVariables.ServerId;
    map['customerId'] = AppVariables.CustomerId;

    print('### map---> $map');

    String urlAPI =
        '${AppVariables.API}/ViewAPIMAP?mobileAppPromotionType=สินค้าหน้า2';

    print('### urlAPI ---> $urlAPI');

    await Dio().get(urlAPI, options: Options(headers: map)).then((value) {
      // print('#### valuve for proDuct -----> $value');

      appController.productP2s.clear();
      for (var element in value.data) {
        ProductResponse productP2 = ProductResponse.fromMap(element);
        appController.productP2s.add(productP2);
      }
    });
  }

  Future<void> savingMtList() async {
    Map<String, dynamic> map = {};
    map['serverId'] = AppVariables.ServerId;
    map['customerId'] = AppVariables.CustomerId;

    print('### map---> $map');

    String urlAPI =
        '${AppVariables.API}/ViewAPISavingMt?searchCustTel=${AppVariables.CUSTTEL}';

    print('### urlAPI ---> $urlAPI');

    await Dio().get(urlAPI, options: Options(headers: map)).then((value) {
      // print('#### valuve for proDuct -----> $value');

      appController.savingMts.clear();
      for (var element in value.data) {
        SavingMtResponse savingMt = SavingMtResponse.fromJson(element);
        appController.savingMts.add(savingMt);
      }
      // AppConstant.SavingId = appController.savingMts[0].savingId;
    });
  }

  Future<void> savingDt() async {
    Map<String, dynamic> map = {};
    map['serverId'] = AppVariables.ServerId;
    map['customerId'] = AppVariables.CustomerId;

    print('### map---> $map');

    String urlAPIsavingDt =
        '${AppVariables.API}/ViewAPIsavingdt?searchSavingId=${AppVariables.SavingId}';
    // String urlAPI = '${AppConstant.API}/ViewAPIsavingdt?searchSavingId=BM00053';
    // print('##### urlAPI ---> $urlAPIsavingDt');

    await Dio()
        .get(urlAPIsavingDt, options: Options(headers: map))
        .then((value) {
      //print('#### valuve for proDuct -----> $value');

      appController.savingDts.clear();
      for (var element in value.data) {
        SavingResponse savingDT = SavingResponse.fromJson(element);
        appController.savingDts.add(savingDT);
      }
    });
  }

  Future<void> mobileAppReward() async {
    Map<String, dynamic> map = {};
    map['serverId'] = AppVariables.ServerId;
    map['customerId'] = AppVariables.CustomerId;

    print('### map---> $map');

    String urlAPI =
        '${AppVariables.API}/mobileappreward?startpage=0&limitpage=${100}';

    print('### urlAPI ---> $urlAPI');

    await Dio().get(urlAPI, options: Options(headers: map)).then((value) {
      // print('#### valuve for proDuct -----> $value');

      appController.mobileAppRewards.clear();
      for (var element in value.data) {
        MobileAppRewardResponse mobileAppReward =
            MobileAppRewardResponse.fromJson(element);
        appController.mobileAppRewards.add(mobileAppReward);
      }
    });
  }

  Future<void> pawnMtList() async {
    Map<String, dynamic> map = {};
    map['serverId'] = AppVariables.ServerId;
    map['customerId'] = AppVariables.CustomerId;

    print('### map---> $map');

    String urlAPI =
        '${AppVariables.API}/ViewAPIPawnMt?searchCustTel=${AppVariables.CUSTTEL}';

    print('### urlAPI ---> $urlAPI');

    await Dio().get(urlAPI, options: Options(headers: map)).then((value) {
      // print('#### valuve for pawnMt -----> $value');

      appController.pawnMts.clear();
      for (var element in value.data) {
        PawnResponse pawnMt = PawnResponse.fromJson(element);
        appController.pawnMts.add(pawnMt);
      }
    });

    // String urlAPIpawnDt =
    //     '${AppVariables.API}/viewapipawnDt?searchPawnID=${AppVariables.PawnId}&searchBranchName=${AppVariables.PawnBranch}';
    // // String urlAPI = '${AppConstant.API}/ViewAPIsavingdt?searchSavingId=BM00053';
    // print('##### urlAPI ---> $urlAPIpawnDt');

    // await Dio().get(urlAPIpawnDt, options: Options(headers: map)).then((value) {
    //   //print('#### valuve for proDuct -----> $value');

    //   appController.pawnDTs.clear();
    //   for (var element in value.data) {
    //     PawnDtResponse pawnDT = PawnDtResponse.fromJson(element);
    //     appController.pawnDTs.add(pawnDT);
    //   }
    // });
  }

  Future<void> pawnDt() async {
    Map<String, dynamic> map = {};
    map['serverId'] = AppVariables.ServerId;
    map['customerId'] = AppVariables.CustomerId;

    print('### map---> $map');

    String urlAPIpawnDt =
        '${AppVariables.API}/viewapipawnDt?searchPawnID=${AppVariables.PawnId}&searchBranchName=${AppVariables.PawnBranch}';
    // String urlAPI = '${AppConstant.API}/ViewAPIsavingdt?searchSavingId=BM00053';
    print('##### urlAPI ---> $urlAPIpawnDt');

    await Dio().get(urlAPIpawnDt, options: Options(headers: map)).then((value) {
      //print('#### valuve for proDuct -----> $value');

      appController.pawnDts.clear();
      for (var element in value.data) {
        PawnDtResponse pawnDT = PawnDtResponse.fromJson(element);
        appController.pawnDts.add(pawnDT);
      }
    });
  }

  Future<void> mobileAppNotiSent() async {
    Map<String, dynamic> map = {};
    map['serverId'] = AppVariables.ServerId;
    map['customerId'] = AppVariables.CustomerId;

    print('### map---> $map');

    String urlAPI = "";
    '${AppVariables.API}/GetMobileAppNotiSent?searchcusttel=${AppVariables.CUSTTEL}&limitShow=20';

    if (AppVariables.searchNotiDateStart == null) {
      urlAPI =
          '${AppVariables.API}/GetMobileAppNotiSent?searchcusttel=${AppVariables.CUSTTEL}&limitShow=20';
    } else {
      urlAPI =
          "${AppVariables.API}/GetMobileAppNotiSent?searchcusttel=${AppVariables.CUSTTEL}&searchNotiDateStart=${AppFormatters.formatDateWhere.format(AppVariables.searchNotiDateStart!)}&searchNotiDateEnd=${AppFormatters.formatDateWhere.format(AppVariables.searchNotiDateEnd!)}";
    }

    print('### urlAPI ---> $urlAPI');

    await Dio().get(urlAPI, options: Options(headers: map)).then((value) {
      // print('#### valuve for proDuct -----> $value');

      appController.mobileAppNotiSents.clear();
      for (var element in value.data) {
        MobileAppNotiSentResponse mobileAppNotiSentResponse =
            MobileAppNotiSentResponse.fromJson(element);
        appController.mobileAppNotiSents.add(mobileAppNotiSentResponse);
      }
    });
  }
}
