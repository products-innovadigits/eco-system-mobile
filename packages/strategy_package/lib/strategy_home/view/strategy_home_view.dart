import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/strategy_home/widgets/strategy_home_body.dart';

class StrategyHomeView extends StatelessWidget {
  const StrategyHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(children: [MainHeader(), StrategyHomeBody()]),
      ),
    );
  }
}
