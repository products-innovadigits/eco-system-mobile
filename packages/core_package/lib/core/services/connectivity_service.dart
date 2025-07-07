import 'package:core_package/core/utility/export.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isInitialized = false;

  void initConnectivity() {
    if (_isInitialized) return;

    // Check initial connection status
    _connectivity.checkConnectivity().then((result) {
      _updateConnectionStatus(result);
    });

    // Listen for connection changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        _updateConnectionStatus(result);
      },
      onError: (error) {
        debugPrint('Connectivity Error: $error');
        mainAppBloc.updateConnectivity(false);
      },
    );

    _isInitialized = true;
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
        mainAppBloc.updateConnectivity(true);
        break;
      case ConnectivityResult.none:
        mainAppBloc.updateConnectivity(false);
        break;
      default:
        mainAppBloc.updateConnectivity(false);
        break;
    }
  }

  Future<bool> checkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      debugPrint('Error checking connection: $e');
      return false;
    }
  }

  void dispose() {
    if (_isInitialized) {
      _connectivitySubscription.cancel();
      _isInitialized = false;
    }
  }
}
