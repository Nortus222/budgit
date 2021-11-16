// ignore_for_file: file_names

int daysBetween(DateTime day1, DateTime day2) {
  day1 = DateTime(day1.year, day1.month, day1.day);
  day2 = DateTime(day2.year, day2.month, day2.day);

  return (day1.difference(day2).inDays);
}
