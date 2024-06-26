import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaUtils {
  static const String MEDIA_TYPE_UNKNOWN = 'unknown';
  static const String MEDIA_TYPE_PICTURE = 'photo';
  static const String MEDIA_TYPE_VIDEO = 'video';
  static const String MEDIA_TYPE_AUDIO = 'audio';

  static List<String> picturesExt = ["jpg", "jpeg", "png", "gif", "bmp"];
  static List<String> audioExt = ["m4a", "flac", "mp3", "aac", "wav", "wma"];
  static List<String> videoExt = ["flv", "mp4", "3gp", "wmv", "mkv", "avi"];

  static String determineType(String path) {
    String ext = path.substring(path.lastIndexOf(".") + 1, path.length);
    if (picturesExt.contains(ext)) {
      return MEDIA_TYPE_PICTURE;
    } else if (videoExt.contains(ext)) {
      return MEDIA_TYPE_VIDEO;
    } else if (audioExt.contains(ext)) {
      return MEDIA_TYPE_AUDIO;
    }
    return MEDIA_TYPE_UNKNOWN;
  }

  static Future<Uint8List?> generateThumbnailFromLocal(String filePath, {int maxWidth=128, int quality=25})async{
    final uint8list = await VideoThumbnail.thumbnailData(
      video: filePath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: maxWidth,
      quality: quality,
    );
    return uint8list;
  }

  static Future<String?> generateThumbnailFromAsset(String assetPath, {int maxWidth=128, int quality=25})async{
    final byteData = await rootBundle.load(assetPath);
    Directory tempDir = await getTemporaryDirectory();

    File tempVideo = File("${tempDir.path}/$assetPath")
      ..createSync(recursive: true)
      ..writeAsBytesSync(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    final filePath = await VideoThumbnail.thumbnailFile(
      video: tempVideo.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    return filePath;
  }

  static Future<Uint8List?> generateThumbnailFromNetwork(String fileUrl, {int maxWidth=128, int quality=25})async{
    final uint8list = await VideoThumbnail.thumbnailData(
      video: fileUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: maxWidth,
      quality: quality,
    );
    return uint8list;
  }

}
