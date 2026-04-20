import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  const WeatherEntity({
    required this.cityName,
    required this.main,
    required this.description,
    required this.iconCode,
    required this.temperatureKelvin,
    required this.pressure,
    required this.humidity,
  });

  final String cityName;
  final String main;
  final String description;
  final String iconCode;
  final double temperatureKelvin;
  final int pressure;
  final int humidity;

  int get temperatureCelsius => (temperatureKelvin - 273).round();

  @override
  List<Object?> get props => [
    cityName,
    main,
    description,
    iconCode,
    temperatureKelvin,
    pressure,
    humidity,
  ];
}
