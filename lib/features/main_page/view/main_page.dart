import 'package:core_system/core/components/custom_screen_type_layout_widget.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/features/main_page/widgets/main_body_mobile_landscape_view.dart';
import 'package:eco_system/features/main_page/widgets/main_body_mobile_portrait_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();

    /// The main page aggregates every system the session can reach, so the
    /// switcher reads "all systems" here.
    UserBloc.currentActiveSystem = null;
  }

  Future<bool> _shouldExit() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      AppCore.warningExitMessage(
        allTranslations.text(LocaleKeys.press_again_to_exit),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          final shouldExit = await _shouldExit();
          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              MainHeader(withBackButton: false),
              CustomScreenTypeLayoutWidget(
                mobilePortrait: (ctx) => MainBodyMobilePortraitView(),
                mobileLandscape: (ctx) => MainBodyMobileLandscapeView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
