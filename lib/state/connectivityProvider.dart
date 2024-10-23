import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  ConnectivityProvider() {
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _updateConnectivityStatus(result.first);
    });
  }

  // Initialize the connectivity status
  Future<void> _initConnectivity() async {
    var result = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(result.first);
  }

  // Update the connectivity status and notify listeners
  void _updateConnectivityStatus(ConnectivityResult result) {
    _connectivityResult = result;
    notifyListeners();
  }

  // Getter to expose the connectivity status
  ConnectivityResult get connectivityStatus => _connectivityResult;

  // Check if the device is offline
  bool get isOffline => _connectivityResult == ConnectivityResult.none;
}
