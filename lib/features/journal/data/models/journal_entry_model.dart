import '../../domain/entities/journal_entry.dart';

class JournalEntryModel {
  const JournalEntryModel({
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

  JournalEntry toEntity() {
    return JournalEntry(
      id: id,
      title: title,
      snippet: snippet,
      date: date,
      timeLabel: timeLabel,
    );
  }
}
