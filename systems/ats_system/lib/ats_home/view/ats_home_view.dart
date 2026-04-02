import 'package:ats_system/ats_shell_home_sections.dart';
import 'package:core_system/core/utility/export.dart';

/// ATS shell home: [MainHeader] + same sections as [AtsModule.homeSections], laid out like
/// [MainBodyMobilePortraitView] (padding, spacing, mapped section builders).
class AtsHomeView extends StatelessWidget {
  const AtsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            const MainHeader(withBackButton: false),
            BlocBuilder<UserBloc, AppState>(
              builder: (context, state) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 70.h),
                        ..._atsHomeSectionWidgets(context),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Uniform 16.h gaps between ATS shell sections (aligned with the app main page).
List<Widget> _atsHomeSectionWidgets(BuildContext context) {
  if (!UserBloc.activeSystems.contains(ActiveSystemEnum.ats)) {
    return [];
  }
  final sections = buildAtsShellHomeSections();
  if (sections.isEmpty) return [];

  final out = <Widget>[];
  final gap = 16.h;
  for (var i = 0; i < sections.length; i++) {
    out.add(sections[i].builder(context));
    if (i < sections.length - 1) {
      out.add(SizedBox(height: gap));
    }
  }
  return out;
}
