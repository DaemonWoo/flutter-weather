import 'package:dartz/dartz.dart';

import '/core/errors/failure.dart';
import '/domain/entities/weather.dart';
import '/domain/repositories/weather.dart';

class GetCurrentWeatherUseCase {
  GetCurrentWeatherUseCase(this.weatherRepository);

  final WeatherRepository weatherRepository;

  Future<Either<Failure, WeatherEntity>> execute(String cityName) {
    return weatherRepository.getCurrentWeather(cityName);
  }
}
