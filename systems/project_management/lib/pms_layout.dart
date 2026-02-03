import 'package:project_management/core/utility/pms_exports.dart';
import 'package:project_management/shared/components/pms_system_switcher.dart';
import 'package:project_management/shared/widgets/pms_bottom_nav_bar.dart';

class PmsLayout extends StatefulWidget {
  final int index;
  final bool showSwitcher;

  const PmsLayout({super.key, this.index = 0, this.showSwitcher = false});

  @override
  State<PmsLayout> createState() => _PmsLayoutState();
}

class _PmsLayoutState extends State<PmsLayout> with WidgetsBindingObserver {
  int _index = 0;
  late bool _showSwitcher;

  @override
  void initState() {
    _index = widget.index;
    _showSwitcher = widget.showSwitcher;
    super.initState();
  }

  Widget layout(int index) => switch (index) {
    0 => const PmsHomeView(),
    1 => const Center(
      child: Text('التقارير', style: TextStyle(fontSize: FontSizes.f32)),
    ),
    2 => const Center(
      child: Text('الإشعارات', style: TextStyle(fontSize: FontSizes.f32)),
    ),
    _ => SizedBox(),
  };

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            body: layout(_index),
            bottomNavigationBar: PmsBottomNavBar(
              index: _index,
              onSelect: (p0) {
                _index = p0;
                setState(() {});
              },
            ),
          ),
          if (_showSwitcher)
            PmsSystemSwitcher(
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

class PmsLayoutArgs {
  final int index;
  final bool showSwitcher;

  const PmsLayoutArgs({this.index = 0, this.showSwitcher = false});
}
