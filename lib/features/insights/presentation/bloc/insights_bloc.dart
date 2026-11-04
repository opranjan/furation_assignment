import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/horoscope.dart';
import '../../domain/entities/insights_content.dart';
import '../../domain/usecases/get_insights.dart';

enum InsightPeriod { yesterday, today, tomorrow, week, month }

sealed class InsightsEvent extends Equatable {
  const InsightsEvent();

  @override
  List<Object?> get props => [];
}

class InsightsStarted extends InsightsEvent {
  const InsightsStarted();
}

class InsightsPeriodSelected extends InsightsEvent {
  const InsightsPeriodSelected(this.period);

  final InsightPeriod period;

  @override
  List<Object?> get props => [period];
}

class InsightsState extends Equatable {
  const InsightsState({
    this.period = InsightPeriod.today,
    required this.displayName,
    required this.birthLabel,
    required this.destinyNumber,
    required this.destinyTitle,
    required this.horoscope,
  });

  final InsightPeriod period;
  final String displayName;
  final String birthLabel;
  final int destinyNumber;
  final String destinyTitle;
  final Horoscope horoscope;

  InsightsState copyWith({InsightPeriod? period}) {
    return InsightsState(
      period: period ?? this.period,
      displayName: displayName,
      birthLabel: birthLabel,
      destinyNumber: destinyNumber,
      destinyTitle: destinyTitle,
      horoscope: horoscope,
    );
  }

  @override
  List<Object?> get props => [
    period,
    displayName,
    birthLabel,
    destinyNumber,
    destinyTitle,
    horoscope,
  ];
}

class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  InsightsBloc(GetInsights getInsights)
    : _getInsights = getInsights,
      super(_map(getInsights.call())) {
    on<InsightsStarted>(_onStarted);
    on<InsightsPeriodSelected>(_onPeriodSelected);
  }

  final GetInsights _getInsights;

  static InsightsState _map(
    InsightsContent content, {
    InsightPeriod period = InsightPeriod.today,
  }) {
    return InsightsState(
      period: period,
      displayName: content.displayName,
      birthLabel: content.birthLabel,
      destinyNumber: content.destinyNumber,
      destinyTitle: content.destinyTitle,
      horoscope: content.horoscope,
    );
  }

  void _onStarted(InsightsStarted event, Emitter<InsightsState> emit) {
    emit(_map(_getInsights.call(), period: state.period));
  }

  void _onPeriodSelected(
    InsightsPeriodSelected event,
    Emitter<InsightsState> emit,
  ) {
    emit(state.copyWith(period: event.period));
  }
}
