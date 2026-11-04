import '../entities/horoscope.dart';
import '../entities/user_profile.dart';

abstract class HomeRepository {
  UserProfile getUser();
  Horoscope getHomeHoroscope();
}
