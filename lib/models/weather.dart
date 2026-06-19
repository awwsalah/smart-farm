class WeatherData {
  const WeatherData({
    required this.region,
    required this.tempC,
    required this.weatherCode,
    required this.fetchedAt,
  });

  final String region;
  final double tempC;
  final int weatherCode;
  final String fetchedAt;

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      region: map['region'] as String,
      tempC: (map['temp_c'] as num).toDouble(),
      weatherCode: map['weather_code'] as int,
      fetchedAt: map['fetched_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'region': region,
      'temp_c': tempC,
      'weather_code': weatherCode,
      'fetched_at': fetchedAt,
    };
  }
}