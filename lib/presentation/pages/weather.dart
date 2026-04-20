import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/constants.dart';
import '/domain/entities/weather.dart';
import '/presentation/bloc/weather_bloc.dart';
import '/presentation/bloc/weather_events.dart';
import '/presentation/bloc/weather_state.dart';

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

  static const _bgDark = Color(0xff0F1117);
  static const _cardColor = Color(0xff1C1F2E);
  static const _accent = Color(0xff4F8EF7);
  static const _textPrimary = Colors.white;
  static const _textSecondary = Color(0xff8A8FA8);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
    context.read<WeatherBloc>().add(OnCityChanged(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
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
                      if (state is WeatherLoaded) {
                        _fadeController
                          ..reset()
                          ..forward();
                      }
                    },
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: switch (state) {
                          WeatherLoading() => const _LoadingIndicator(),
                          WeatherLoaded(:final result) => FadeTransition(
                            opacity: _fadeAnimation,
                            child: _WeatherCard(
                              key: const Key('weather_data'),
                              result: result,
                            ),
                          ),
                          WeatherLoadFailure(:final message) => _ErrorMessage(
                            message: message,
                          ),
                          _ => const _EmptyState(),
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
      backgroundColor: _bgDark,
      floating: true,
      snap: true,
      centerTitle: true,
      title: const Text(
        'WEATHER',
        style: TextStyle(
          color: _textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 4,
        ),
      ),
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.start,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Search city...',
        hintStyle: const TextStyle(color: Color(0xff8A8FA8)),
        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xff8A8FA8)),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, val, __) => val.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xff8A8FA8),
                    size: 18,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
        fillColor: const Color(0xff1C1F2E),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff4F8EF7), width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

// ─── Weather Card ─────────────────────────────────────────────────────────────

class _WeatherCard extends StatelessWidget {
  const _WeatherCard({super.key, required this.result});

  final WeatherEntity result; // replace with your actual model type

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroWeather(result: result),
        const SizedBox(height: 16),
        _StatsGrid(result: result),
      ],
    );
  }
}

class _HeroWeather extends StatelessWidget {
  const _HeroWeather({required this.result});

  final WeatherEntity result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xff1C1F2E),
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff1C1F2E), Color(0xff131627)],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.cityName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.description,
                      style: const TextStyle(
                        color: Color(0xff8A8FA8),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Image.network(
                Urls.weatherIcon(result.iconCode),
                width: 64,
                height: 64,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.cloud, color: Colors.white54, size: 48),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${result.temperatureCelsius}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.w200,
                  height: 1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '°C',
                  style: TextStyle(
                    color: Color(0xff4F8EF7),
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              _WeatherBadge(label: result.main),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherBadge extends StatelessWidget {
  const _WeatherBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xff4F8EF7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff4F8EF7)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Stats Grid ───────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.result});

  final WeatherEntity result;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.thermostat_rounded,
            label: 'Temperature',
            value: '${result.temperatureCelsius}°',
            iconColor: const Color(0xffFF6B6B),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            icon: Icons.compress_rounded,
            label: 'Pressure',
            value: '${result.pressure} hPa',
            iconColor: const Color(0xffFFBF42),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            icon: Icons.water_drop_rounded,
            label: 'Humidity',
            value: '${result.humidity}%',
            iconColor: const Color(0xff4F8EF7),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1C1F2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Color(0xff8A8FA8), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ─── Auxiliary States ─────────────────────────────────────────────────────────

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      heightFactor: 4,
      child: CircularProgressIndicator(
        color: Color(0xff4F8EF7),
        strokeWidth: 2,
      ),
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
            color: Color(0xff8A8FA8),
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xff8A8FA8), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      heightFactor: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_rounded, color: Color(0xff2E3248), size: 52),
          SizedBox(height: 12),
          Text(
            'Search for a city to get started',
            style: TextStyle(color: Color(0xff8A8FA8), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
