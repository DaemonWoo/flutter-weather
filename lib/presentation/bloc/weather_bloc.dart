import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '/domain/use_cases/get_current_weather.dart';
import '/presentation/bloc/weather_events.dart';
import '/presentation/bloc/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;

  WeatherBloc(this._getCurrentWeatherUseCase) : super(WeatherEmpty()) {
    on<OnCityChanged>((event, emit) async {
      final query = event.cityName.trim();
      if (query.isEmpty) {
        if (state is! WeatherEmpty) {
          emit(WeatherEmpty());
        }
        return;
      }

      emit(WeatherLoading());

      final result = await _getCurrentWeatherUseCase.execute(query);

      result.fold(
        (failure) {
          emit(WeatherLoadFailure(failure.message));
        },
        (data) {
          emit(WeatherLoaded(data));
        },
      );
    }, transformer: debounceLatest(const Duration(milliseconds: 500)));
  }
}

EventTransformer<T> debounceLatest<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}
