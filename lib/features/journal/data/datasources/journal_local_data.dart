import '../models/journal_entry_model.dart';

class JournalLocalData {
  const JournalLocalData();

  static final entries = <JournalEntryModel>[
    JournalEntryModel(
      id: '1',
      title: 'A Day To Remember',
      snippet:
          'Today felt like a good day to slow down. I finally made time for something I had been putting off.',
      date: DateTime(2026, 8, 12),
      timeLabel: '06:30 PM',
    ),
    JournalEntryModel(
      id: '2',
      title: 'A Thought To Keep',
      snippet:
          "I'm learning to trust my own pace and enjoy the journey instead of rushing the ending.",
      date: DateTime(2026, 8, 10),
      timeLabel: '06:30 PM',
    ),
    JournalEntryModel(
      id: '3',
      title: 'Something I Realized',
      snippet:
          'Small steps can still move me closer to where I want to be, even on quiet days.',
      date: DateTime(2026, 8, 9),
      timeLabel: '06:30 PM',
    ),
    JournalEntryModel(
      id: '4',
      title: 'New Intentions',
      snippet:
          'Set a gentle intention for October: show up for my goals without perfectionism getting in the way.',
      date: DateTime(2026, 10, 5),
      timeLabel: '07:20 PM',
    ),
    JournalEntryModel(
      id: '5',
      title: 'Soft Reset',
      snippet:
          'Cleared my desk, lit a candle, and journaled for twenty minutes. Small resets create big shifts.',
      date: DateTime(2026, 10, 18),
      timeLabel: '10:05 AM',
    ),
    JournalEntryModel(
      id: '6',
      title: 'November Beginnings',
      snippet:
          'The month opens with clarity. I feel ready to revisit unfinished goals with a kinder pace.',
      date: DateTime(2026, 11, 1),
      timeLabel: '08:00 AM',
    ),
  ];
}
