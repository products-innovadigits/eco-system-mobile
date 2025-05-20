import 'package:eco_system/utility/export.dart';

class Gender extends StatelessWidget {
  const Gender({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<FiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.gender),
            style: AppTextStyles.w400.copyWith(fontSize: 12)),
        8.sh,
        CustomDropList(
          list: filtrationBloc.genders,
          hint: allTranslations.text(LocaleKeys.select_gender),
          onChanged: (value) {},
        ),
      ],
    );
  }
}
