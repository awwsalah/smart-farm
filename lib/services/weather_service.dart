import 'dart:convert';

import 'package:app/config/app_strings.dart';
import 'package:app/config/regions.dart';
import 'package:app/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  /// Maps Open-Meteo WMO weather codes to Somali (PRD Section 9).
  static String mapWeatherCodeToSomali(int code) {
    if (code == 0) return 'Cir saafi ah';
    if (code >= 1 && code <= 3) return 'Daruuro qayb ah';
    if (code == 45 || code == 48) return 'Ceeryaamo';
    if (code >= 51 && code <= 67) return 'Roob yar';
    if (code >= 80 && code <= 82) return 'Roob daran';
    if (code >= 95 && code <= 99) return 'Onkod iyo roob';
    return AppStrings.weatherNoData;
  }

  Future<WeatherData> fetchCurrent(SomaliRegion region) async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=${region.latitude}'
      '&longitude=${region.longitude}'
      '&current=temperature_2m,weather_code',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw WeatherServiceException(AppStrings.error);
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final current = json['current'] as Map<String, dynamic>?;

    if (current == null) {
      throw WeatherServiceException(AppStrings.error);
    }

    return WeatherData(
      region: region.name,
      tempC: (current['temperature_2m'] as num).toDouble(),
      weatherCode: current['weather_code'] as int,
      fetchedAt: DateTime.now().toIso8601String(),
    );
  }
}

class WeatherServiceException implements Exception {
  WeatherServiceException(this.message);
  final String message;

  @override
  String toString() => message;
}