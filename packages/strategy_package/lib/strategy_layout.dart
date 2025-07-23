import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';
import 'package:core_package/core/widgets/nav_app.dart';
import 'package:strategy_package/strategy_home/view/strategy_home_view.dart';

class StrategyLayout extends StatefulWidget {
  final int index;

  const StrategyLayout({super.key, this.index = 0});

  @override
  State<StrategyLayout> createState() => _StrategyLayoutState();
}

class _StrategyLayoutState extends State<StrategyLayout> with WidgetsBindingObserver {
  int _index = 0;


  @override
  void initState() {
    _index = widget.index;
    super.initState();
  }

  Widget fregmant(int index) {
    switch (index) {
      case 0:
        return const StrategyHomeView();
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
    return Scaffold(
      body: fregmant(_index),
      bottomNavigationBar: NavApp(
        index: _index,
        onSelect: (p0) {
          _index = p0;
          setState(() {});
        },
      ),
    );
  }
}
