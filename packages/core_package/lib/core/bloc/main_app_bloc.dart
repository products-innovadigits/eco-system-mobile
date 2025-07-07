import 'dart:developer';

import 'package:core_package/core/utility/export.dart';

class MainAppBloc {
  final lang = BehaviorSubject<String>();
  final _notifyRoute = BehaviorSubject<String?>();
  final messageNumber = BehaviorSubject<int?>();
  final theme = BehaviorSubject<bool?>();
  final connectivity = BehaviorSubject<bool?>();
  final search = BehaviorSubject<String>();
  final shared = SharedHelper();

  Function(String) get updateLang => lang.sink.add;
  Function(bool) get updateTheme => theme.sink.add;
  Function(int) get updateMessageNumber => messageNumber.sink.add;
  Function(String) get updateRoute => _notifyRoute.sink.add;
  Function(bool) get updateConnectivity => connectivity.sink.add;
  Function(String) get updateSearch => search.sink.add;

  Stream<String> get langStream => lang.stream.asBroadcastStream();
  Stream<int?> get messageNumberStream =>
      messageNumber.stream.asBroadcastStream();
  Stream<bool?> get themeStream => theme.stream.asBroadcastStream();
  Stream<String?> get routeStream => _notifyRoute.stream.asBroadcastStream();
  Stream<bool?> get connectivityStream =>
      connectivity.stream.asBroadcastStream();

  void dispose() {
    lang.close();
    theme.close();
    messageNumber.close();
    _notifyRoute.close();
    connectivity.close();
  }

  Future<void> getShared() async {
    String lang = await allTranslations.getPreferredLanguage();
    //here we check the theme value if true, it's be dark
    // if(route == null || route == ""){
    //     route = await splashBloC.getRoute();
    // }
    log('LANG $lang');
    updateLang(lang);
  }
}

MainAppBloc mainAppBloc = MainAppBloc();
