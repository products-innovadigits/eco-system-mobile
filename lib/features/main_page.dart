import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';
import 'package:core_package/core/widgets/nav_app.dart';

import 'home/view/home_view.dart';

class MainPage extends StatefulWidget {
  final int index;

  const MainPage({super.key, this.index = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int _index = 0;
  DateTime? _lastBackPressTime;

  Future<bool> _shouldExit() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      AppCore.warningExitMessage(allTranslations.text(LocaleKeys.press_again_to_exit));
      return false;
    }
    return true;
  }

  @override
  void initState() {
    _index = widget.index;
    super.initState();
  }

  Widget fregmant(int index) {
    switch (index) {
      case 0:
        return const HomeView();
      case 1:
        return const Center(child: Text('التقارير' , style: TextStyle(fontSize: FontSizes.f32)),);
      case 2:
        return const Center(child: Text('الإشعارات' , style: TextStyle(fontSize: FontSizes.f32)),);
      case 3:
        return const Center(child: Text('المزيد' , style: TextStyle(fontSize: FontSizes.f32)),);
      default:
        return SizedBox();
    }
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
        body: fregmant(_index),
        bottomNavigationBar: NavApp(
          index: _index,
          onSelect: (p0) {
            _index = p0;
            setState(() {});
          },
        ),
      ),
    );
  }
}
