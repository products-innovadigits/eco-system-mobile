import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:core_system/core/widgets/nav_app.dart';
import 'package:pms_system/pms_home/view/pms_home_view.dart';

class PmsLayout extends StatefulWidget {
  final int index;

  const PmsLayout({super.key, this.index = 0});

  @override
  State<PmsLayout> createState() => _PmsLayoutState();
}

class _PmsLayoutState extends State<PmsLayout> with WidgetsBindingObserver {
  int _index = 0;

  @override
  void initState() {
    _index = widget.index;
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
      child: Scaffold(
        body: layout(_index),
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
