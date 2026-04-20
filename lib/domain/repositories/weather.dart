import 'package:dartz/dartz.dart';

import '/core/errors/failure.dart';
import '/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String cityName);
}
