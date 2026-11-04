import 'package:get_it/get_it.dart';

import '../network/api_service.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_horoscope.dart';
import '../../features/home/domain/usecases/get_user.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/insights/data/repositories/insights_repository_impl.dart';
import '../../features/insights/domain/repositories/insights_repository.dart';
import '../../features/insights/domain/usecases/get_insights.dart';
import '../../features/insights/presentation/bloc/insights_bloc.dart';
import '../../features/journal/data/repositories/journal_repository_impl.dart';
import '../../features/journal/domain/repositories/journal_repository.dart';
import '../../features/journal/domain/usecases/get_journal_entries.dart';
import '../../features/journal/presentation/bloc/journal_bloc.dart';

/// Service locator. Repositories live for the process. Blocs are factories
/// so each route gets its own instance, which [BlocProvider] closes.
final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (getIt.isRegistered<HomeRepository>()) return;

  getIt.registerLazySingleton(ApiService.new);

  getIt.registerLazySingleton<HomeRepository>(HomeRepositoryImpl.new);
  getIt.registerLazySingleton<JournalRepository>(JournalRepositoryImpl.new);
  getIt.registerLazySingleton<InsightsRepository>(InsightsRepositoryImpl.new);

  getIt.registerLazySingleton(() => GetUser(getIt()));
  getIt.registerLazySingleton(() => GetHomeHoroscope(getIt()));
  getIt.registerLazySingleton(() => GetJournalEntries(getIt()));
  getIt.registerLazySingleton(() => GetInsights(getIt()));

  getIt.registerFactory(
    () => HomeBloc(getUser: getIt(), getHomeHoroscope: getIt()),
  );
  getIt.registerFactory(() => JournalBloc(getIt()));
  getIt.registerFactory(() => InsightsBloc(getIt()));
}
