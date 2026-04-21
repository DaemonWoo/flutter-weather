import 'package:flutter/material.dart';

import '/core/constants.dart';
import '/domain/entities/weather.dart';
import '/theme.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.result});

  final WeatherEntity result;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WeatherSummary(
          cityName: result.cityName,
          temperature: result.temperatureCelsius,
          description: result.description,
          iconCode: result.iconCode,
          label: result.main,
        ),
        const SizedBox(height: 16),
        _StatsGrid(
          temperature: result.temperatureCelsius,
          pressure: result.pressure,
          humidity: result.humidity,
        ),
      ],
    );
  }
}

class _WeatherSummary extends StatelessWidget {
  const _WeatherSummary({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.label,
  });

  final String cityName;
  final num temperature;
  final String description;
  final String iconCode;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.bgDark,
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.bgDark, AppTheme.cardColor],
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
                      cityName,
                      style: AppTheme.headlineStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Image.network(
                Urls.weatherIcon(iconCode),
                width: 64,
                height: 64,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.cloud,
                  color: AppTheme.errorIconColor,
                  size: 48,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$temperature',
                style: TextStyle(
                  color: AppTheme.textPrimary,
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
                    color: AppTheme.accent,
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              _WeatherBadge(label: label),
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
        color: AppTheme.accent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accent),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.temperature,
    required this.pressure,
    required this.humidity,
  });

  final num temperature;
  final int pressure;
  final int humidity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.thermostat_rounded,
            label: 'Temperature',
            value: '$temperature°',
            iconColor: AppTheme.statsTemperature,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            icon: Icons.compress_rounded,
            label: 'Pressure',
            value: '$pressure hPa',
            iconColor: AppTheme.statsPressure,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            icon: Icons.water_drop_rounded,
            label: 'Humidity',
            value: '$humidity%',
            iconColor: AppTheme.accent,
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
        color: AppTheme.bgDark,
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
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
