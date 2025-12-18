import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class NoInternetManager {
  final ValueNotifier<bool> internetState = ValueNotifier<bool>(true);

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NoInternetManager() {
    _init();
  }

  void _init() async {
    final result = await _connectivity.checkConnectivity();
    _updateState(result);

    _subscription = _connectivity.onConnectivityChanged.listen(_updateState);
  }

  void _updateState(List<ConnectivityResult> results) {
    final hasConnection =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);

    internetState.value = hasConnection;
  }

  Future<void> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateState(result);
  }

  void dispose() {
    _subscription?.cancel();
    internetState.dispose();
  }
}
