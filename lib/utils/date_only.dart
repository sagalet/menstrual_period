/// Normalizes a [DateTime] to year/month/day only (strips time components).
DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// Returns true when two dates fall on the same calendar day.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
