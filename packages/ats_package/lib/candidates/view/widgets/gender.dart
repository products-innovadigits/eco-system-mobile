import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class Gender extends StatelessWidget {
  const Gender({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<FiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          allTranslations.text(LocaleKeys.gender),
          style: AppTextStyles.w400.copyWith(fontSize: 12.w),
        ),
        8.sh,
        CustomDropList(
          list: filtrationBloc.genders,
          hint: filtrationBloc.genderController.text.isEmpty
              ? allTranslations.text(LocaleKeys.select_gender)
              : filtrationBloc.genderController.text,
          onChanged: (value) {
            filtrationBloc.genderController.text = value.name ?? '';
            filtrationBloc.add(UpdateGender(arguments: value));
          },
        ),
      ],
    );
  }
}
