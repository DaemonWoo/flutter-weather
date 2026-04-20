import 'dart:io';

import 'package:dartz/dartz.dart';

import '/core/errors/exceptions.dart';
import '/core/errors/failure.dart';
import '/data/data_sources/weather.dart';
import '/domain/entities/weather.dart';
import '/domain/repositories/weather.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  WeatherRepositoryImpl({required this.weatherRemoteDataSource});

  final WeatherRemoteDataSource weatherRemoteDataSource;

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(
    String cityName,
  ) async {
    try {
      final result = await weatherRemoteDataSource.getCurrentWeather(cityName);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure('An error has occurred'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
