import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '/domain/use_cases/get_current_weather.dart';
import '/presentation/bloc/weather_events.dart';
import '/presentation/bloc/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;

  WeatherBloc(this._getCurrentWeatherUseCase) : super(WeatherState()) {
    on<OnCityChanged>((event, emit) async {
      final query = event.cityName.trim();
      if (query.isEmpty) {
        emit(state.copyWith(status: WeatherStatus.initial));
        return;
      }

      emit(state.copyWith(status: WeatherStatus.loading));

      final result = await _getCurrentWeatherUseCase.execute(query);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: WeatherStatus.failure,
              errorMessage: failure.message,
            ),
          );
        },
        (data) {
          emit(state.copyWith(status: WeatherStatus.loaded, weather: data));
        },
      );
    }, transformer: debounceLatest(const Duration(milliseconds: 500)));
  }
}

EventTransformer<T> debounceLatest<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}
