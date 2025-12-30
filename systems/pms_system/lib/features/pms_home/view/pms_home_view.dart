
import 'package:pms_system/core/utility/pms_exports.dart';

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
