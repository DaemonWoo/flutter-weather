import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/presentation/bloc/weather_bloc.dart';
import '/presentation/bloc/weather_events.dart';
import '/presentation/bloc/weather_state.dart';
import '/presentation/components/weather_card.dart';
import '/theme.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onCityChanged(String query) {
    if (query.trim().length > 2) {
      context.read<WeatherBloc>().add(OnCityChanged(query.trim()));
    } else if (query.trim().isEmpty) {
      context.read<WeatherBloc>().add(OnCityChanged(query.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SearchBar(
                    controller: _searchController,
                    onChanged: _onCityChanged,
                  ),
                  const SizedBox(height: 28),
                  BlocConsumer<WeatherBloc, WeatherState>(
                    listener: (context, state) {
                      if (state.status case WeatherStatus.loaded) {
                        _fadeController.forward(from: 0);
                      }
                    },
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: switch (state.status) {
                          WeatherStatus.loading => const _LoadingIndicator(),
                          WeatherStatus.loaded => FadeTransition(
                            opacity: _fadeAnimation,
                            child: WeatherCard(
                              key: const Key('weather_data'),
                              result: state.weather!,
                            ),
                          ),
                          WeatherStatus.failure => _ErrorMessage(
                            message: state.errorMessage!,
                          ),
                          _ => const _InitialPrompt(),
                        },
                      );
                    },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppTheme.bgDark,
      floating: true,
      snap: true,
      centerTitle: true,
      title: const Text('WEATHER', style: AppTheme.headlineStyle),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.start,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Search city...',
        hintStyle: const TextStyle(color: AppTheme.textSecondary),
        prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.iconColor),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, val, _) => val.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppTheme.textSecondary,
                    size: 18,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
        fillColor: AppTheme.bgDark,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.accent, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      heightFactor: 4,
      child: CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: AppTheme.iconColor,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _InitialPrompt extends StatelessWidget {
  const _InitialPrompt();

  @override
  Widget build(BuildContext context) {
    return const Center(
      heightFactor: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_rounded, color: AppTheme.cardColor, size: 52),
          SizedBox(height: 12),
          Text(
            'Search for a city to get started',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
