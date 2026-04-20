import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/injection_container.dart';
import '/presentation/pages/weather.dart';
import 'presentation/bloc/weather_bloc.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => locator<WeatherBloc>())],
      child: const MaterialApp(
        home: WeatherPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
