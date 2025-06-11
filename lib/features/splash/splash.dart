import 'package:eco_system/components/animated_widget.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/splash/splash_bloc.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/text_styles.dart';

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
            body: Container(
              width: context.w,
              height: context.h,
              padding: EdgeInsets.only(bottom: context.h * 0.1),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.images.newSplashBg.path),
                      fit: BoxFit.cover)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Styles.logo()
                        .animate()
                        .scale(
                          begin: const Offset(1.0, 1.0),
                          end: const Offset(0.5, 0.5),
                          duration: 1000.ms,
                          delay: 0.ms,
                          curve: Curves.easeInOut,
                          alignment: Alignment.bottomCenter,
                        )
                        .then(delay: 200.ms)
                        .shimmer(duration: 1000.ms, curve: Curves.easeInOut),
                    SizedBox(height: 4.h),
                    AnimatedWidgets(
                      durationMilli: 2000,
                      verticalOffset: 0.0,
                      horizontalOffset: 0.0,
                      child: Text(
                        "Nawah",
                        style: AppTextStyles.w800.copyWith(
                          fontSize: 32,
                          color: Styles.WHITE_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
