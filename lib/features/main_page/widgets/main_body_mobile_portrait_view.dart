import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/app/modules/modules_registry.dart';

class MainBodyMobilePortraitView extends StatelessWidget {
  const MainBodyMobilePortraitView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          spacing: 16.h,
          children: [
            const SizedBox(height: 70),
            ...ModulesRegistry.appSections.map(
              (section) => section.builder(context),
            ),
            16.sh,
          ],
        ),
      ),
    );
  }
}
