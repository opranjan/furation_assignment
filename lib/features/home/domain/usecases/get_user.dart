import '../entities/user_profile.dart';
import '../repositories/home_repository.dart';

class GetUser {
  const GetUser(this._repository);

  final HomeRepository _repository;

  UserProfile call() => _repository.getUser();
}
