import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class Location extends StatelessWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<FiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.location),
            style: AppTextStyles.w400.copyWith(fontSize: 12)),
        8.sh,
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
