import 'package:equatable/equatable.dart';

import '/domain/entities/weather.dart';

enum WeatherStatus { initial, loading, loaded, failure }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final WeatherEntity? weather;
  final String? errorMessage;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.weather,
    this.errorMessage,
  });

  WeatherState copyWith({
    WeatherStatus? status,
    WeatherEntity? weather,
    String? errorMessage,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, weather, errorMessage];
}
