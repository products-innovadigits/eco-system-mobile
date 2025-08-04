import 'package:firebase_analytics/firebase_analytics.dart';

import '../../utility/utility.dart';

class FirebaseAnalyticsHelper {
  static FirebaseAnalyticsHelper? _analytics;
  static FirebaseAnalytics? _instance;
  FirebaseAnalyticsHelper._internal();

  factory FirebaseAnalyticsHelper() {
    _analytics ??= FirebaseAnalyticsHelper._internal();
    return _analytics!;
  }

  setup() async {
    _instance = FirebaseAnalytics.instance;
  }

  launchEvent({required String name, required Map<String, Object>? body}) async {
    cprint('<<<<< LAUNCH EVENT ${name.toUpperCase()} >>>>>');
    _instance!.logEvent(name: name, parameters: body);
  }

  Future launchEventSignUp({required Map<String, Object>? body, required String method}) async {
    cprint('<<<<< LAUNCH EVENT SIGN UP \n ${body!.entries} >>>>>');
    await _instance!.logSignUp(parameters: body, signUpMethod: method);
  }

  Future launchEventAddToCart({required Map<String, Object>? body}) async {
    cprint('<<<<< LAUNCH EVENT ADD TO CART \n ${body!.entries} >>>>>');
    await _instance!.logAddToCart(parameters: body);
  }

  Future launchEventShipping({required Map<String, Object>? body}) async {
    cprint('<<<<< LAUNCH EVENT SHIPPING \n ${body!.entries} >>>>>');
    await _instance!.logAddShippingInfo(parameters: body);
  }

  Future launchEventPayment({required Map<String, Object>? body}) async {
    cprint('<<<<< LAUNCH EVENT PAYMENT \n ${body!.entries} >>>>>');
    await _instance!.logAddPaymentInfo(parameters: body);
  }
}
