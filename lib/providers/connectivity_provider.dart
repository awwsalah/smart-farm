import 'package:app/services/connectivity_service.dart';
import 'package:flutter/foundation.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool isOnline = true;
  bool isChecking = false;

  Future<void> check() async {
    if (isChecking) return;
    isChecking = true;
    notifyListeners();

    isOnline = await ConnectivityService.hasConnection();

    isChecking = false;
    notifyListeners();
  }
}