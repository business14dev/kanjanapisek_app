import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanjanapisek_app/src/models/mobileappnotisent_response.dart';
import 'package:kanjanapisek_app/src/models/mobileappreward_reponse.dart';
import 'package:kanjanapisek_app/src/models/pawn_response.dart';
import 'package:kanjanapisek_app/src/models/pawndt_response.dart';
import 'package:kanjanapisek_app/src/models/product_response.dart';
import 'package:kanjanapisek_app/src/models/saving_response.dart';
import 'package:kanjanapisek_app/src/models/savingmt_response.dart';

class AppController extends GetxController {
  RxBool load = true.obs;

  RxList<ProductResponse> productModels = <ProductResponse>[].obs;

  RxList<ProductResponse> newProductP1s = <ProductResponse>[].obs;

  RxList<ProductResponse> newPromotionP2s = <ProductResponse>[].obs;

  RxList<ProductResponse> menuP2s = <ProductResponse>[].obs;

  RxList<ProductResponse> productP2s = <ProductResponse>[].obs;

  RxList<SavingMtResponse> savingMts = <SavingMtResponse>[].obs;

  RxList<SavingResponse> savingDts = <SavingResponse>[].obs;

  RxList<MobileAppRewardResponse> mobileAppRewards = <MobileAppRewardResponse>[].obs;

  RxList<PawnResponse> pawnMts = <PawnResponse>[].obs;

  RxList<PawnDtResponse> pawnDts = <PawnDtResponse>[].obs;

  RxList<MobileAppNotiSentResponse> mobileAppNotiSents = <MobileAppNotiSentResponse>[].obs;

  // เพิ่ม GlobalKey
  final GlobalKey itemKey = GlobalKey();

  //Start จุดๆเลื่อนออมทอง
  int selectedIndexSaving = 0;

  void setSelectedIndexSving(int index) {
    selectedIndexSaving = index;
    update(); // เพื่อแจ้งให้ Flutter รู้ว่า state มีการเปลี่ยนแปลง
  }

  // เพิ่ม ScrollController
  ScrollController saivngScrollController = ScrollController();

  void updateIndexOnScroll() {
    double scrollPosition = saivngScrollController.position.pixels;
    double itemWidth = 340; // สมมุติว่าความกว้างของแต่ละรายการใน ListView
    int newIndex = (scrollPosition / itemWidth).round();
    if (newIndex != selectedIndexSaving) {
      setSelectedIndexSving(newIndex);
    }
  }
  //End จุดๆเลื่อน ขายฝาก

  //Start จุดๆเลื่อน ขายฝาก

  ScrollController pawnScrollController = ScrollController();

  int selectedIndexPawn = 0;

  void setSelectedIndexPawn(int index) {
    selectedIndexPawn = index;
    update();
  }

  void updatePawnIndexOnScroll() {
    double scrollPosition = pawnScrollController.position.pixels;
    double itemWidth = 300.0; // สมมุติว่าแต่ละไอเท็มมีความกว้าง
    int newIndex = (scrollPosition / itemWidth).round();
    if (newIndex != selectedIndexPawn) {
      setSelectedIndexPawn(newIndex);
    }
  }
}
