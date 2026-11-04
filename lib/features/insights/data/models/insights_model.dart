import '../../../home/data/models/horoscope_model.dart';
import '../../domain/entities/insights_content.dart';

class InsightsModel {
  const InsightsModel({
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
  final HoroscopeModel horoscope;

  InsightsContent toEntity() {
    return InsightsContent(
      displayName: displayName,
      birthLabel: birthLabel,
      guidance: guidance,
      destinyNumber: destinyNumber,
      destinyTitle: destinyTitle,
      horoscope: horoscope.toEntity(),
    );
  }
}
