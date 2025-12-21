import 'dart:developer';

import 'package:core_system/core/utility/export.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() => _instance;

  ConnectivityService._internal();

  StreamSubscription<InternetStatus>? _internetSubscription;
  Timer? _periodicCheck;
  bool _isInitialized = false;
  bool _lastKnownStatus = true;

  void initConnectivity() {
    if (_isInitialized) return;

    // Check initial connection status
    _checkAndUpdate();

    // Listen for real internet connection changes
    _internetSubscription = InternetConnection().onStatusChange.listen(
      (InternetStatus status) {
        log('Internet status changed: $status');
        _updateConnectionStatus(status);
      },
      onError: (error) {
        log('Internet connection error: $error');
        mainAppBloc.updateConnectivity(false);
      },
    );

    // Periodic check every 3 seconds as fallback (in case stream doesn't fire)
    _periodicCheck = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkAndUpdate();
    });

    _isInitialized = true;
    log('ConnectivityService initialized - real internet monitoring active');
  }

  Future<void> _checkAndUpdate() async {
    try {
      final hasInternet = await InternetConnection().hasInternetAccess;

      // Only update if status changed
      if (hasInternet != _lastKnownStatus) {
        log('Internet status changed: $_lastKnownStatus -> $hasInternet');
        _lastKnownStatus = hasInternet;
        mainAppBloc.updateConnectivity(hasInternet);
      }
    } catch (e) {
      log('Error in periodic internet check: $e');
      mainAppBloc.updateConnectivity(false);
    }
  }

  void _updateConnectionStatus(InternetStatus status) {
    final hasInternet = status == InternetStatus.connected;
    log('Internet status updated: $hasInternet (status: $status)');
    _lastKnownStatus = hasInternet;
    mainAppBloc.updateConnectivity(hasInternet);
  }

  Future<bool> checkConnection() async {
    try {
      log('Manual internet connection check');
      final hasInternet = await InternetConnection().hasInternetAccess;

      _lastKnownStatus = hasInternet;
      mainAppBloc.updateConnectivity(hasInternet);

      return hasInternet;
    } catch (e) {
      log('Error checking internet connection: $e');
      mainAppBloc.updateConnectivity(false);
      return false;
    }
  }

  void dispose() {
    if (_isInitialized) {
      _internetSubscription?.cancel();
      _internetSubscription = null;
      _periodicCheck?.cancel();
      _periodicCheck = null;
      _isInitialized = false;
      log('ConnectivityService disposed');
    }
  }
}
