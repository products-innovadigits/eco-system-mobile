import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/app/modules/modules_registry.dart';

class MainBodyMobileLandscapeView extends StatelessWidget {
  const MainBodyMobileLandscapeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          MainHeader.bodyTopOffset(context),
          24,
          16.h,
        ),
        child: Column(
          spacing: 16.h,
          children: ModulesRegistry.appSections
              .map((section) => section.builder(context))
              .toList(),
        ),
      ),
    );
  }
}
