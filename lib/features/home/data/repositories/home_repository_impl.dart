import '../../domain/entities/horoscope.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl();

  @override
  UserProfile getUser() => HomeLocalData.user.toEntity();

  @override
  Horoscope getHomeHoroscope() => HomeLocalData.horoscope.toEntity();
}
