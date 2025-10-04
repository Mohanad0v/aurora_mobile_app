import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      List<ConnectivityResult> connectivityResult = (await (Connectivity().checkConnectivity()));
      return (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.bluetooth));
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }
}
