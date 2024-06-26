import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerUtil {
  static Future<CroppedFile?> pickImage({bool isDocument=false}) async {
    ImagePicker picker = ImagePicker();
    XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: 900,
      maxHeight: 1080,
    );
    if (photo?.path == null) return null;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: photo!.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: isDocument ? 1.5 : 1.0),
      compressFormat: ImageCompressFormat.jpg,
      maxHeight: 1080,
      maxWidth: 1080,
      uiSettings: [
        AndroidUiSettings(
          hideBottomControls: true,
        )
      ],
    );
    if(croppedFile == null ){
      return null;
    }

    // // Compress the image
    // Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
    //   croppedFile.path,
    //   minHeight: 1080,
    //   minWidth: 1080,
    // );
    //
    // if(compressedImage == null){
    //   return null;
    // }

    return croppedFile;
  }

  static Future<File> _saveTempImage(List<int> imageBytes, String tempFileName) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/$tempFileName');

    await tempFile.writeAsBytes(imageBytes);
    return tempFile;
  }
}
