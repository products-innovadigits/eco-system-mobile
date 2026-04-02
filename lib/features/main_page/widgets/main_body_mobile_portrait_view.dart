import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/features/main_page/widgets/main_page_section_spacing.dart';

class MainBodyMobilePortraitView extends StatelessWidget {
  const MainBodyMobilePortraitView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, AppState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 70.h),
                ...mainPageSectionWidgets(context),
                SizedBox(height: mainPageSectionGap),
              ],
            ),
          ),
        );
      },
    );
  }
}
