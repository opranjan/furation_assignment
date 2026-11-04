import '../entities/horoscope.dart';
import '../repositories/home_repository.dart';

class GetHomeHoroscope {
  const GetHomeHoroscope(this._repository);

  final HomeRepository _repository;

  Horoscope call() => _repository.getHomeHoroscope();
}
