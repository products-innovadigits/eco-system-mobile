import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/strategy_home/widgets/strategy_home_body.dart';

class StrategyHomeView extends StatelessWidget {
  const StrategyHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: const Stack(children: [MainHeader(), StrategyHomeBody()]),
      ),
    );
  }
}
