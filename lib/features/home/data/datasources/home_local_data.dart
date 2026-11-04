import '../models/horoscope_model.dart';
import '../models/user_profile_model.dart';

class HomeLocalData {
  const HomeLocalData();

  static const user = UserProfileModel(
    name: 'Saniya',
    initials: 'S',
    element: 'Air',
    modality: 'Mutable',
    rulingPlanet: 'Mercury',
    sunSign: 'Cancer',
    moonSign: 'Leo',
    birthDateLabel: '13 Aug 1998',
  );

  static const horoscope = HoroscopeModel(
    sign: 'Gemini',
    dateLabel: '13 August 2026',
    body:
        'Your natural curiosity is your strength today. Stay open to new ideas, but give yourself time to focus before making decisions.',
    focusOfDay: 'Career',
    favourableDirection: 'North',
    luckyColour: 'Pink',
    luckyNumber: 5,
    funFact:
        'Geminis are ruled by Mercury — communication, wit, and adaptability are your natural gifts.',
  );
}
