import 'package:http/http.dart' as http;

/// Lightweight online check using the allowed `http` package only.
class ConnectivityService {
  static Future<bool> hasConnection() async {
    try {
      final response = await http
          .head(Uri.parse('https://api.open-meteo.com'))
          .timeout(const Duration(seconds: 4));
      return response.statusCode >= 200 && response.statusCode < 500;
    } catch (_) {
      return false;
    }
  }
}