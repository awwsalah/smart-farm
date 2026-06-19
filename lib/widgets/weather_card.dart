import 'package:app/config/app_strings.dart';
import 'package:app/config/app_theme.dart';
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
          return const _WeatherSkeleton();
        }

        final weather = weatherProvider.weather;

        return Container(
          decoration: BoxDecoration(
            gradient: AppGradients.weather,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wb_sunny_outlined, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.weather,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                      ),
                      const Spacer(),
                      if (weatherProvider.isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else
                        IconButton(
                          onPressed: weatherProvider.refresh,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          tooltip: AppStrings.refreshWeather,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.selectRegion,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: weatherProvider.selectedRegionName,
                    isExpanded: true,
                    dropdownColor: AppColors.primaryDark,
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
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
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      WeatherService.mapWeatherCodeToSomali(weather.weatherCode),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${AppStrings.weatherUpdated}: ${_formatUpdated(weather.fetchedAt) ?? weather.fetchedAt}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                    ),
                    if (weatherProvider.isFromCache) ...[
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.offline,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFFFFCDD2),
                            ),
                      ),
                    ],
                  ] else ...[
                    Text(
                      AppStrings.weatherNoData,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.weatherFetchFailed,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.weatherAttribution,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WeatherSkeleton extends StatelessWidget {
  const _WeatherSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.sage.withValues(alpha: 0.4),
      highlightColor: AppColors.sage.withValues(alpha: 0.7),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          gradient: AppGradients.weather,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}