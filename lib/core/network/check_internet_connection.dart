import 'package:flutter/material.dart';

import '../errors/no_internet_connection.dart';
import 'no_internet_manager.dart';

class CheckInternetConnection extends StatefulWidget {
  final Widget child;

  const CheckInternetConnection({super.key, required this.child});

  @override
  State<CheckInternetConnection> createState() =>
      _CheckInternetConnectionState();
}

class _CheckInternetConnectionState extends State<CheckInternetConnection> {
  late final NoInternetManager _noInternetManager;

  @override
  void initState() {
    super.initState();
    _noInternetManager = NoInternetManager();
  }

  @override
  void dispose() {
    _noInternetManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _noInternetManager.internetState,
      builder: (context, isConnected, _) {
        if (isConnected) {
          return widget.child;
        }

        return Scaffold(
          body: NoInternetConnection(
            onRetry: _noInternetManager.checkConnectivity,
          ),
        );
      },
    );
  }
}
