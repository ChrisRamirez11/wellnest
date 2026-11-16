bool canUpdateCheckbox(DateTime date) {
  date = DateTime(date.year, date.month, date.day);
  final today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  return (date.isBefore(today) || date.isAtSameMomentAs(today));
}
