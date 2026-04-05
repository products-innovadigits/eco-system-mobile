import 'package:ats_system/ats_home/view/ats_home_view.dart';
import 'package:ats_system/shared/components/ats_system_switcher.dart';
import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:core_system/core/widgets/nav_app.dart';
import 'package:core_system/features/settings/view/settings_view.dart';

class AtsLayout extends StatefulWidget {
  final int index;
  final bool showSwitcher;

  const AtsLayout({super.key, this.index = 0, this.showSwitcher = false});

  @override
  State<AtsLayout> createState() => _AtsLayoutState();
}

class _AtsLayoutState extends State<AtsLayout> with WidgetsBindingObserver {
  late int _index;
  late bool _showSwitcher;

  @override
  void initState() {
    _index = widget.index;
    _showSwitcher = widget.showSwitcher;
    super.initState();
  }

  Widget layout(int index) => switch (index) {
        0 => const AtsHomeView(),
        1 => const Center(
            child: Text('التقارير', style: TextStyle(fontSize: FontSizes.f32)),
          ),
        2 => const SettingsView(),
        _ => const SizedBox(),
      };

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            body: layout(_index),
            bottomNavigationBar: NavApp(
              index: _index,
              onSelect: (i) {
                setState(() {
                  _index = i;
                });
              },
            ),
          ),
          if (_showSwitcher)
            AtsSystemSwitcher(
              onComplete: () {
                setState(() {
                  _showSwitcher = false;
                });
              },
            ),
        ],
      ),
    );
  }
}

class AtsLayoutArgs {
  final int index;
  final bool showSwitcher;

  const AtsLayoutArgs({this.index = 0, this.showSwitcher = false});
}
