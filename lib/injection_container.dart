import 'package:clear_structure/core/network/network_info.dart';
import 'package:clear_structure/core/util/input_converter.dart';
import 'package:clear_structure/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clear_structure/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clear_structure/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clear_structure/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clear_structure/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clear_structure/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clear_structure/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future init() async {
  // Features - Number Trivia
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        concrete: sl(),
        random: sl(),
        input: sl(),
      ));
  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: sl(),
    ),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
  // Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
