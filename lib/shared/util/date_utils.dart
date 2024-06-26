DateTime? parseMyDate(String formattedDate) {
  final List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  List<String> dateParts = formattedDate.split('/');
  if (dateParts.length == 3) {
    int day = int.tryParse(dateParts[0]) ?? 1;
    int month = monthNames.indexOf(dateParts[1]) + 1;
    int year = int.tryParse(dateParts[2]) ?? DateTime.now().year;

    try {
      return DateTime(year, month, day);
    } catch (e) {
      print('Error creating DateTime: $e');
      return null;
    }
  }

  return null;
}