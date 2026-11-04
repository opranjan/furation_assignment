import '../../../home/domain/entities/horoscope.dart';

class InsightsContent {
  const InsightsContent({
    required this.displayName,
    required this.birthLabel,
    required this.guidance,
    required this.destinyNumber,
    required this.destinyTitle,
    required this.horoscope,
  });

  final String displayName;
  final String birthLabel;
  final String guidance;
  final int destinyNumber;
  final String destinyTitle;
  final Horoscope horoscope;
}
