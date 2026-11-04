import '../../domain/entities/insights_content.dart';
import '../../domain/repositories/insights_repository.dart';
import '../datasources/insights_local_data.dart';

class InsightsRepositoryImpl implements InsightsRepository {
  const InsightsRepositoryImpl();

  @override
  InsightsContent getContent() => InsightsLocalData.content.toEntity();
}
