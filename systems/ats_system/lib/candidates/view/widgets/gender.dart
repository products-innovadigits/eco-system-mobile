import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class Gender extends StatelessWidget {
  const Gender({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<AtsFiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.gender),
            style: context.textTheme.bodySmall),
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
