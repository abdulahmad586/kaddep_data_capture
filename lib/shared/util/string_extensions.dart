extension StringExtension on String {
  String capitalize() {
    if(isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeWords() {
    List<String> words = split(" ");
    for(int i=0; i<words.length; i++){
      words[i] = words[i].capitalize();
    }
    return words.join(" ");
  }
}