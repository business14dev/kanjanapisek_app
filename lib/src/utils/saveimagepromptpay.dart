import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:kanjanapisek_app/src/utils/appformatters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class SaveImagePromptpay {
  static Future<void> saveImage(Uint8List image, BuildContext context) async {
    if (kIsWeb) {
      try {
        // ใช้โค้ดสำหรับบันทึกในเว็บ
        final time = AppFormatters.formatDateAll.format(DateTime.now());

        // Create an image name
        var filename = 'PromptPay_${time}.png';

        // ใช้โค้ดสำหรับบันทึกในเว็บ
        final blob = html.Blob([image]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("บันทึกรูปเรียบร้อยแล้ว"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print("Error saving image web: $e");
      }
    } else {
      try {
        // ตรวจสอบและขอสิทธิ์ก่อนบันทึก
        bool hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          await Gal.requestAccess();
        }

        final time = AppFormatters.formatDateAll.format(DateTime.now());

        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/PromptPay_${time}.png';

        final file = await File(filePath);
        await file.writeAsBytes(image);
        await Gal.putImage(file.path, album: "BSSGold");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("บันทึกรูปเรียบร้อยแล้ว"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print("Error saving image: $e");
      }
    }
  }
}
