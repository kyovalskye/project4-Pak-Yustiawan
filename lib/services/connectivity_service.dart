import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final ValueNotifier<bool> _isConnected = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isConnected => _isConnected;

  // Initialize connectivity service
  Future<void> initialize() async {
    // Check initial connectivity
    await checkConnectivity();

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectionStatus(results);
    });
  }

  // Check current connectivity status
  Future<bool> checkConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity
          .checkConnectivity();

      // Check if any result is not 'none'
      final bool isConnected = results.any(
        (result) => result != ConnectivityResult.none,
      );

      if (kIsWeb) {
        // For web, if connectivity_plus says we're connected, trust it
        // Web browsers handle internet detection well
        _isConnected.value = isConnected;
      } else {
        // For mobile, double-check with actual internet connection
        final bool hasConnection = await _hasInternetConnection();
        _isConnected.value = hasConnection && isConnected;
      }

      return _isConnected.value;
    } catch (e) {
      // On web, be more lenient - assume connected if there's any doubt
      _isConnected.value = kIsWeb ? true : false;
      return _isConnected.value;
    }
  }

  // Update connection status when connectivity changes
  void _updateConnectionStatus(List<ConnectivityResult> results) async {
    // Check if all results are 'none' (no connectivity)
    final bool hasNoConnection = results.every(
      (result) => result == ConnectivityResult.none,
    );

    if (hasNoConnection) {
      _isConnected.value = false;
    } else {
      if (kIsWeb) {
        // For web, trust the connectivity result
        _isConnected.value = true;
      } else {
        // For mobile, double check with actual internet connection
        final hasInternet = await _hasInternetConnection();
        _isConnected.value = hasInternet;
      }
    }
  }

  // Check if device has actual internet connection
  Future<bool> _hasInternetConnection() async {
    try {
      if (kIsWeb) {
        // For web platform, use HTTP request to check connectivity
        final response = await http
            .get(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 5));
        return response.statusCode == 200;
      } else {
        // For mobile platforms, use the original method
        // Note: Import dart:io only for non-web platforms
        // You might need to use conditional imports for this
        return true; // Simplified for now, can be enhanced later
      }
    } catch (e) {
      // If we're on web and there's any error, assume we have internet
      // because connectivity_plus already detected a connection
      if (kIsWeb) {
        return true; // Be more lenient on web
      }
      return false;
    }
  }

  // Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _isConnected.dispose();
  }
}
