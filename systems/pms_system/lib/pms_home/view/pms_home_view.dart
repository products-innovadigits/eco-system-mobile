import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/pms_home/widgets/pms_home_body.dart';

class PmsHomeView extends StatelessWidget {
  const PmsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(children: [MainHeader(), PmsHomeBody()]),
      ),
    );
  }
}
