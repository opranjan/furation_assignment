import '../../domain/entities/horoscope.dart';

class HoroscopeModel {
  const HoroscopeModel({
    required this.sign,
    required this.dateLabel,
    required this.body,
    required this.focusOfDay,
    required this.favourableDirection,
    required this.luckyColour,
    required this.luckyNumber,
    required this.funFact,
  });

  final String sign;
  final String dateLabel;
  final String body;
  final String focusOfDay;
  final String favourableDirection;
  final String luckyColour;
  final int luckyNumber;
  final String funFact;

  Horoscope toEntity() {
    return Horoscope(
      sign: sign,
      dateLabel: dateLabel,
      body: body,
      focusOfDay: focusOfDay,
      favourableDirection: favourableDirection,
      luckyColour: luckyColour,
      luckyNumber: luckyNumber,
      funFact: funFact,
    );
  }
}
