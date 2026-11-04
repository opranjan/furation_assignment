import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/journal_entry.dart';
import '../../domain/usecases/get_journal_entries.dart';

sealed class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object?> get props => [];
}

class JournalStarted extends JournalEvent {
  const JournalStarted();
}

class JournalMonthSelected extends JournalEvent {
  const JournalMonthSelected(this.month);

  final int month;

  @override
  List<Object?> get props => [month];
}

class JournalState extends Equatable {
  const JournalState({required this.selectedMonth, required this.entries});

  final int selectedMonth;
  final List<JournalEntry> entries;

  JournalState copyWith({int? selectedMonth, List<JournalEntry>? entries}) {
    return JournalState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object?> get props => [selectedMonth, entries];
}

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc(GetJournalEntries getJournalEntries)
    : _getJournalEntries = getJournalEntries,
      super(
        JournalState(
          selectedMonth: 10,
          // Figma shows the August cards while Oct is the selected chip.
          entries: getJournalEntries.call(month: 8),
        ),
      ) {
    on<JournalStarted>(_onStarted);
    on<JournalMonthSelected>(_onMonthSelected);
  }

  final GetJournalEntries _getJournalEntries;

  static const months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  void _onStarted(JournalStarted event, Emitter<JournalState> emit) {
    emit(
      state.copyWith(
        selectedMonth: 10,
        entries: _getJournalEntries.call(month: 8),
      ),
    );
  }

  void _onMonthSelected(
    JournalMonthSelected event,
    Emitter<JournalState> emit,
  ) {
    emit(
      state.copyWith(
        selectedMonth: event.month,
        entries: _getJournalEntries.call(month: event.month),
      ),
    );
  }
}
