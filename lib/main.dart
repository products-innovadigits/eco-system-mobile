// Flutter core imports
// Third-party imports
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

// Local imports
import 'bloc/main_app_bloc.dart';
import 'config/colors/light_colors.dart';
import 'config/providers.dart';
import 'config/themes/themes.dart';
import 'firebase_options.dart';
import 'helpers/notification_helper/notification_helper.dart';
import 'helpers/shared_helper.dart';
import 'helpers/styles.dart';
import 'helpers/translation/all_translation.dart';
import 'helpers/translation/translations.dart';
import 'navigation/custom_navigation.dart';
import 'navigation/routes.dart';
import 'services/connectivity_service.dart';
import 'utility/un_focus.dart';
import 'widgets/connectivity_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  // await MediaCacheManager.instance.init(
  //   encryptionPassword: 'i love flutter',
  //   daysToExpire: 12098,
  // );

  if (!kDebugMode) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseNotifications.setUpFirebase();
  }
  await SharedHelper.init();
  await allTranslations.init();
  await dotenv.load(fileName: ".env");
  await mainAppBloc.getShared();

  // Initialize connectivity service
  final connectivityService = ConnectivityService();
  connectivityService.initConnectivity();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return MultiBlocProvider(
      providers: ProviderList.providers,
      child: StreamBuilder<String>(
        stream: mainAppBloc.langStream,
        builder: (context, lang) {
          return lang.hasData
              ? ConnectivityWrapper(
                  child: MaterialApp(
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: const TextScaler.linear(1),
                        ),
                        child: Unfocus(child: child ?? const SizedBox.shrink()),
                      );
                    },
                    initialRoute: Routes.SPLASH,
                    onGenerateRoute: CustomNavigator.onCreateRoute,
                    navigatorKey: CustomNavigator.navigatorState,
                    navigatorObservers: [CustomNavigator.routeObserver],
                    debugShowCheckedModeBanner: false,
                    scaffoldMessengerKey: CustomNavigator.scaffoldState,
                    locale: Locale(lang.data!, ''),
                    supportedLocales: allTranslations.supportedLocales(),
                    localizationsDelegates: const [
                      TranslationsDelegate(),
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    title: "Nawah",
                    themeMode: ThemeMode.light,
                    theme: Themes.lightTheme().themeData.copyWith(
                          appBarTheme: Themes.lightTheme()
                              .themeData
                              .appBarTheme
                              .copyWith(
                                iconTheme: const IconThemeData(
                                  color: LightColor.black,
                                ),
                                titleTextStyle: TextStyle(
                                  color: LightColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: lang.data == 'en'
                                      ? Styles.FONT_EN
                                      : Styles.FONT_AR,
                                ),
                              ),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          textTheme:
                              Themes.lightTheme().themeData.textTheme.apply(
                                    fontFamily: lang.data == 'en'
                                        ? Styles.FONT_EN
                                        : Styles.FONT_AR,
                                  ),
                        ),
                  ),
                )
              : Container();
        },
      ),
    );
  }
}
