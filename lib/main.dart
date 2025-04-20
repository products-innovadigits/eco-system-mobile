import 'package:eco_system/bloc/main_app_bloc.dart';
import 'package:eco_system/config/colors/light_colors.dart';
import 'package:eco_system/config/themes/themes.dart';
import 'package:eco_system/helpers/shared_helper.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/helpers/translation/translations.dart';
import 'package:eco_system/utility/un_focus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'config/providers.dart';
import 'firebase_options.dart';
import 'helpers/notification_helper/notification_helper.dart';
import 'helpers/styles.dart';
import 'navigation/custom_navigation.dart';
import 'navigation/routes.dart';

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
    mainAppBloc.getShared();
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
              ? MaterialApp(
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1),
                    ),
                    child: Unfocus(child: child!),
                  ),
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
                  title: "Eco System",
                  themeMode: ThemeMode.light,
                  theme: Themes.lightTheme().themeData.copyWith(
                        appBarTheme:
                            Themes.lightTheme().themeData.appBarTheme.copyWith(
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
                        textTheme:
                            Themes.lightTheme().themeData.textTheme.apply(
                                  fontFamily: lang.data == 'en'
                                      ? Styles.FONT_EN
                                      : Styles.FONT_AR,
                                ),
                      ),
                )
              : Container();
        },
      ),
    );
  }
}
