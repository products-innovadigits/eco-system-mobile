// Flutter core imports
// Third-party imports
import 'package:core_package/core/config/providers.dart';
import 'package:core_package/core/config/themes/themes.dart';
import 'package:core_package/core/helpers/notification_helper/notification_helper.dart';
import 'package:core_package/core/helpers/translation/translations.dart';
import 'package:core_package/core/navigation/routes.dart';
import 'package:core_package/core/services/connectivity_service.dart';
import 'package:core_package/core/utility/export.dart' hide Routes;
import 'package:core_package/core/utility/un_focus.dart';
import 'package:core_package/core/widgets/connectivity_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

// Local imports
import 'firebase_options.dart';
import 'navigation/custom_navigation.dart';

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light));
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
                          child:
                              Unfocus(child: child ?? const SizedBox.shrink()),
                        );
                      },
                      initialRoute: Routes.SPLASH,
                      onGenerateRoute: AppRouter.onGenerateRoute,
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
                      theme: Themes.lightTheme().themeData
                      // .copyWith(
                      //   appBarTheme: Themes.lightTheme()
                      //       .themeData
                      //       .appBarTheme
                      //       .copyWith(
                      //           iconTheme: const IconThemeData(
                      //             color: LightColor.black,
                      //           ),
                      //           titleTextStyle: TextStyle(
                      //             color: context.color.primary,
                      //             fontSize: FontSizes.f16,
                      //             fontWeight: FontWeight.w600,
                      //             fontFamily: lang.data == 'en'
                      //                 ? Styles.FONT_EN
                      //                 : Styles.FONT_AR,
                      //           ),
                      //           systemOverlayStyle: SystemUiOverlayStyle(
                      //             statusBarColor: Colors.transparent,
                      //             statusBarBrightness: Brightness.dark,
                      //             statusBarIconBrightness: Brightness.dark,
                      //             systemNavigationBarColor:
                      //                 Colors.transparent,
                      //             systemNavigationBarIconBrightness:
                      //                 Brightness.dark,
                      //           )),
                      //   highlightColor: Colors.transparent,
                      //   splashColor: Colors.transparent,
                      //   textTheme:
                      //       Themes.lightTheme().themeData.textTheme.apply(
                      //             fontFamily: lang.data == 'en'
                      //                 ? Styles.FONT_EN
                      //                 : Styles.FONT_AR,
                      //           ),
                      // ),
                      ),
                )
              : Container();
        },
      ),
    );
  }
}
