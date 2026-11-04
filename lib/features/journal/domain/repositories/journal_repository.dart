import '../entities/journal_entry.dart';

abstract class JournalRepository {
  List<JournalEntry> getJournalEntries({int? month});
}
