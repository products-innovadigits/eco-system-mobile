import 'package:core_package/core/utility/export.dart';
import 'package:pms_package/pms_home/widgets/pms_home_body.dart';

class PmsHomeView extends StatelessWidget {
  const PmsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(children: [MainHeader(), PmsHomeBody()]),
      ),
    );
  }
}
