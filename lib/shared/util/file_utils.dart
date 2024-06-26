import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils{
  static Future<String> imageToBase64(String filePath) async {
    File file = File(filePath);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  static Future<String> blobToBase64(Uint8List fileBlob) async {
    // fileBlob = await FlutterImageCompress.compressWithList(fileBlob, quality: 75);
    return 'data:image/jpeg;base64,${base64Encode(fileBlob)}';
  }

  static Uint8List base64ToBlob(String fileBase64){
    fileBase64 = fileBase64.replaceFirst("data:image/jpeg;base64,", "").replaceFirst("data:image/jpeg;base64,", "");
    return base64Decode(fileBase64);
  }

  static Future<Uint8List> imageToBlob(String filePath) async {
    File file = File(filePath);
    final bytes = await file.readAsBytes();
    return bytes;
  }

  static Future<String> writeToFile(String text, String fileName) async {
    final Directory directory = (await getExternalStorageDirectories())!.first;
    final File file = File('${directory.path}/$fileName');
    await file.writeAsString(text);
    return file.path;
  }
}