import 'package:app/config/app_strings.dart';
import 'package:app/config/regions.dart';
import 'package:app/providers/weather_provider.dart';
import 'package:app/services/weather_service.dart';
import 'package:app/widgets/animated_temperature.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  String? _formatUpdated(String raw) {
    try {
      return DateFormat('d MMM y, HH:mm').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, _) {
        if (weatherProvider.isLoading && weatherProvider.weather == null) {
          return _WeatherSkeleton();
        }

        final weather = weatherProvider.weather;
        final theme = Theme.of(context);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.wb_sunny_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.weather,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (weatherProvider.isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        onPressed: weatherProvider.refresh,
                        icon: const Icon(Icons.refresh),
                        tooltip: AppStrings.refreshWeather,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.selectRegion,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: weatherProvider.selectedRegionName,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: SomaliRegions.all
                      .map(
                        (region) => DropdownMenuItem<String>(
                          value: region.name,
                          child: Text(region.name),
                        ),
                      )
                      .toList(),
                  onChanged: weatherProvider.isLoading
                      ? null
                      : (value) {
                          if (value != null) {
                            weatherProvider.setRegion(value);
                          }
                        },
                ),
                const SizedBox(height: 16),
                if (weather != null) ...[
                  AnimatedTemperature(
                    celsius: weather.tempC,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
            
                  const SizedBox(height: 4),
                  Text(
                    WeatherService.mapWeatherCodeToSomali(weather.weatherCode),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AppStrings.weatherUpdated}: ${_formatUpdated(weather.fetchedAt) ?? weather.fetchedAt}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (weatherProvider.isFromCache) ...[
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.offline,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ] else ...[
                  Text(
                    AppStrings.weatherNoData,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.weatherFetchFailed,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  AppStrings.weatherAttribution,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WeatherSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      highlightColor: Theme.of(context).colorScheme.surface,
      child: Card(
        child: SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 120, color: Colors.white),
                const Spacer(),
                Container(height: 32, width: 80, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 14, width: 160, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}