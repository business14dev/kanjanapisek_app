import 'package:intl/intl.dart';

class AppFormatters {
   static final DateFormat formatDate = DateFormat("dd/MM/yyyy");
  static final NumberFormat formatNumber = NumberFormat("#,##0");
  static final NumberFormat formatNumber2 = NumberFormat("#,##0.00");
  static final NumberFormat formatNumber3 = NumberFormat("#,##0.000");
  static final NumberFormat formatNumber4 = NumberFormat("#,##0.0000");
  static final DateFormat formatDateToDatabase = DateFormat("yyyy-MM-dd");
  static final DateFormat formatDateWhere = DateFormat("MM/dd/yyyy");
  static final DateFormat formatDateYYYY = DateFormat("yyyy");
  static final DateFormat formatDateAll = DateFormat("yyyy-MM-dd_HH-mm-ss");
}
