class SomaliRegion {
  const SomaliRegion({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;
}

/// Somali region presets — no GPS; user picks from this list.
abstract final class SomaliRegions {
  static const defaultRegionName = 'Muqdisho';

  static const List<SomaliRegion> all = [
    SomaliRegion(name: 'Muqdisho', latitude: 2.0469, longitude: 45.3182),
    SomaliRegion(name: 'Hargeysa', latitude: 9.5600, longitude: 44.0650),
    SomaliRegion(name: 'Baydhabo', latitude: 3.1140, longitude: 43.6490),
    SomaliRegion(name: 'Kismaayo', latitude: -0.3582, longitude: 42.5454),
    SomaliRegion(name: 'Boosaaso', latitude: 11.2842, longitude: 49.1816),
    SomaliRegion(name: 'Gaalkacyo', latitude: 6.7700, longitude: 47.4300),
  ];

  static SomaliRegion get defaultRegion => all.first;

  static SomaliRegion? byName(String name) {
    for (final region in all) {
      if (region.name == name) return region;
    }
    return null;
  }
}