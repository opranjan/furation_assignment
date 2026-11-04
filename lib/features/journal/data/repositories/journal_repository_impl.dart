import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/journal_local_data.dart';

class JournalRepositoryImpl implements JournalRepository {
  const JournalRepositoryImpl();

  @override
  List<JournalEntry> getJournalEntries({int? month}) {
    final all = JournalLocalData.entries.map((entry) => entry.toEntity());
    if (month == null) return List.unmodifiable(all);
    return all
        .where((entry) => entry.date.month == month)
        .toList(growable: false);
  }
}
