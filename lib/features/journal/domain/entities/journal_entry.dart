class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.title,
    required this.snippet,
    required this.date,
    required this.timeLabel,
  });

  final String id;
  final String title;
  final String snippet;
  final DateTime date;
  final String timeLabel;
}
