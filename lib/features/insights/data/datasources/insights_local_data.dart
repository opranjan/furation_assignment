import '../../../home/data/models/horoscope_model.dart';
import '../models/insights_model.dart';

class InsightsLocalData {
  const InsightsLocalData();

  static const content = InsightsModel(
    displayName: 'Gilli Gaurav Singh',
    birthLabel: 'You • Sep 22, 2001',
    guidance:
        'Stay open to unexpected opportunities. Trust your instincts, explore something new, and avoid overthinking your next move.',
    destinyNumber: 7,
    destinyTitle: 'The Seeker',
    horoscope: HoroscopeModel(
      sign: 'Leo',
      dateLabel: 'Today',
      body:
          'Give yourself time to heal and focus on your well-being today. Avoid unhealthy habits and choose nourishing food. Stay patient — positive career support is on the way, while a true friend brings warmth and connection.',
      focusOfDay: 'Career',
      favourableDirection: 'North',
      luckyColour: 'Pink',
      luckyNumber: 5,
      funFact:
          "Leo is ruled by the Sun, which is why it's traditionally associated with confidence, creativity, warmth, and a natural desire to shine.",
    ),
  );
}
