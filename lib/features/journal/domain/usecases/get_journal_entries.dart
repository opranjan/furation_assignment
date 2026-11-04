import '../entities/journal_entry.dart';
import '../repositories/journal_repository.dart';

class GetJournalEntries {
  const GetJournalEntries(this._repository);

  final JournalRepository _repository;

  List<JournalEntry> call({int? month}) {
    return _repository.getJournalEntries(month: month);
  }
}
