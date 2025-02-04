import 'package:eco_system/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/components/animated_widget.dart';
import 'package:eco_system/features/splah/splash_bloc.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(Click()),
      child: BlocBuilder<SplashBloc, AppState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Styles.PRIMARY_COLOR,
              body: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 70.0),
                      child: RichText(
                        text: TextSpan(
                            text: "Eco System App",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Styles.WHITE_COLOR)),
                      )),
                  Expanded(
                    child: Center(
                      child: AnimatedWidgets(
                        durationMilli: 2000.0,
                        verticalOffset: 0.0,
                        horizontalOffset: 0.0,
                        child: Styles.splash,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: RichText(
                        text: TextSpan(
                            text: "Powered By",
                            children: [
                              TextSpan(
                                  text: " innovaDigits",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Styles.ACCENT_COLOR))
                            ],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Styles.WHITE_COLOR)),
                      )),
                ],
              ));
        },
      ),
    );
  }
}
