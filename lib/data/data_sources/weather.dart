import 'dart:convert';

import 'package:http/http.dart' as http;

import '/core/constants.dart';
import '/core/errors/exceptions.dart';
import '/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String cityName);
}

class WeatherRemoteDataSourceImpl extends WeatherRemoteDataSource {
  WeatherRemoteDataSourceImpl({required this.client});

  final http.Client client;

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final response = await client.get(
      Uri.parse(Urls.currentWeatherByName(cityName)),
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw const ServerException();
    }
  }
}
