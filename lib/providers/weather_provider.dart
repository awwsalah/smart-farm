import 'package:app/config/app_strings.dart';
import 'package:app/config/regions.dart';
import 'package:app/data/repositories/weather_cache_repository.dart';
import 'package:app/models/weather.dart';
import 'package:app/services/weather_service.dart';
import 'package:flutter/foundation.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherProvider({
    WeatherService? service,
    WeatherCacheRepository? cacheRepository,
  })  : _service = service ?? WeatherService(),
        _cacheRepository = cacheRepository ?? WeatherCacheRepository();

  final WeatherService _service;
  final WeatherCacheRepository _cacheRepository;

  WeatherData? weather;
  String selectedRegionName = SomaliRegions.defaultRegionName;
  bool isLoading = false;
  bool isFromCache = false;

  Future<void> initialize() async {
    final cached = await _cacheRepository.getCached();
    if (cached != null) {
      weather = cached;
      selectedRegionName = cached.region;
      isFromCache = true;
      notifyListeners();
    }
    await refresh();
  }

  Future<void> refresh() async {
    isLoading = true;
    notifyListeners();

    final region =
        SomaliRegions.byName(selectedRegionName) ?? SomaliRegions.defaultRegion;

    try {
      final fresh = await _service.fetchCurrent(region);
      await _cacheRepository.save(fresh);
      weather = fresh;
      isFromCache = false;
    } catch (_) {
      if (weather == null) {
        final cached = await _cacheRepository.getCached();
        if (cached != null) {
          weather = cached;
          isFromCache = true;
        }
      } else {
        isFromCache = true;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setRegion(String regionName) async {
    selectedRegionName = regionName;
    await refresh();
  }

  String get conditionText {
    if (weather == null) return AppStrings.weatherNoData;
    return WeatherService.mapWeatherCodeToSomali(weather!.weatherCode);
  }
}