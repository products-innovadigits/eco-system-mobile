import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class Location extends StatelessWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<AtsFiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          allTranslations.text(LocaleKeys.location),
          style: AppTextStyles.w400.copyWith(fontSize: 12),
        ),
        SizedBox(height: 8.h),
        // CustomDropList(
        //   list: filtrationBloc.locations,
        //   hint: allTranslations.text(LocaleKeys.select_your_location),
        //   onChanged: (value) {},
        // ),
        CustomTextField(
          hint: allTranslations.text(LocaleKeys.select_your_location),
          controller: filtrationBloc.locationController,
          onChanged: (location) {},
        ),
      ],
    );
  }
}
