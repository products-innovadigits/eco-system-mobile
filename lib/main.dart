
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:eco_system/helpers/shared_helper.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/helpers/translation/translations.dart';
import 'package:eco_system/main_blocs/main_app_bloc.dart';
import 'app_config/providers.dart';
import 'helpers/styles.dart';
import 'navigation/custom_navigation.dart';
import 'navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // DynamicLinkHelper.init();
  await SharedHelper.init();
  // FirebaseNotifications.init();
  await allTranslations.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    mainAppBloc.getShared();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
          return lang.hasData ? MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0, ),
              child: child ?? Container(),
            ),
            initialRoute: Routes.SPLASH,
            navigatorKey: CustomNavigator.navigatorState,
            onGenerateRoute: CustomNavigator.onCreateRoute,
            navigatorObservers: [CustomNavigator.routeObserver],
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: CustomNavigator.scaffoldState,
            locale: Locale(lang.data!, ''),
            supportedLocales:
            allTranslations.supportedLocales(),
            localizationsDelegates: const [
              TranslationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            title: "eco_system",
            theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
              primaryColor: Styles.PRIMARY_COLOR,
              colorScheme: ThemeData().colorScheme.copyWith(secondary: Styles.ACCENT_COLOR),
              fontFamily: lang.data == 'en' ? Styles.FONT_EN : Styles.FONT_AR ,
              scaffoldBackgroundColor: Styles.WHITE_COLOR
            ),
            // home: AddPropertyPage(),
          ) : Container();
        }
      ),
    );
  }
}
























