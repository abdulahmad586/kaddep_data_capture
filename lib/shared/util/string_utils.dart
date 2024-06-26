import 'dart:math';

class StringUtils {
  static String randomString(int len) {
    List<String> fullChars =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvqxyz0123456789"
        .split("");
    String generated = "";
    Random rand = Random();
    for (int i = 0; i < len; i++) {
      generated += fullChars[rand.nextInt(fullChars.length)];
    }
    return generated;
  }

  static String durationToString(Duration d) {
    if (d.inSeconds > 59) {
      double minutes = d.inSeconds / 60;
      int minute = minutes.floor();
      int seconds = ((minutes - minute) * 60).round();
      return '${minute > 9 ? minute : '0$minute'}:${seconds > 9 ? seconds : '0$seconds'}';
    }

    return '00:${d.inSeconds > 9 ? d.inSeconds.round() : '0${d.inSeconds.round()}'}';
  }
}
