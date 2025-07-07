import 'package:core_package/core/utility/export.dart';
import 'package:eco_system/features/splash/splash_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
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
              color: context.color.primary,
              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //         image: AssetImage(Assets.images.newBrandingSplashBg.path),
              //         fit: BoxFit.cover)),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Icon(Icons.circle, color: Styles.WHITE_COLOR, size: 30.h),
                    Styles.logo(height: 180.h, width: 180.w)
                        .animate(
                            onComplete: (controller) => controller.repeat())
                        .scale(
                          begin: const Offset(1.1, 1.1),
                          end: const Offset(1.0, 1.0),
                          duration: 500.ms,
                          curve: Curves.easeInOut,
                        )
                        .then()
                        .scale(
                          begin: const Offset(1.0, 1.0),
                          end: const Offset(1.1, 1.1),
                          duration: 500.ms,
                          curve: Curves.easeInOut,
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

// SizedBox(height: 12.h),
// AnimatedWidgets(
//   durationMilli: 2000,
//   verticalOffset: 0.0,
//   horizontalOffset: 0.0,
//   child: Text(
//     "Nawah",
//     style: AppTextStyles.w800.copyWith(
//       fontSize: 32,
//       color: Styles.WHITE_COLOR,
//     ),
//   ),
// ),
