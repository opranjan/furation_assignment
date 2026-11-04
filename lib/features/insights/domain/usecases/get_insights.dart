import '../entities/insights_content.dart';
import '../repositories/insights_repository.dart';

class GetInsights {
  const GetInsights(this._repository);

  final InsightsRepository _repository;

  InsightsContent call() => _repository.getContent();
}
