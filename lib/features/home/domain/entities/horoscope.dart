class Horoscope {
  const Horoscope({
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
}
