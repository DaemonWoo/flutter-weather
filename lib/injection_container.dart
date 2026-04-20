import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '/data/data_sources/weather.dart';
import '/data/repositories/weather.dart';
import '/domain/repositories/weather.dart';
import '/domain/use_cases/get_current_weather.dart';
import '/presentation/bloc/weather_bloc.dart';

final locator = GetIt.instance;

void setupLocator() {
  // bloc
  locator.registerFactory(() => WeatherBloc(locator()));

  // usecase
  locator.registerLazySingleton(() => GetCurrentWeatherUseCase(locator()));

  // repository
  locator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(weatherRemoteDataSource: locator()),
  );

  // data source
  locator.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(client: locator()),
  );

  // external
  locator.registerLazySingleton(() => http.Client());
}
