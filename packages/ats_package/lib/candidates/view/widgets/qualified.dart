import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class Qualified extends StatelessWidget {
  const Qualified({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<FiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.qualification),
            style: AppTextStyles.w400.copyWith(fontSize: 12)),
        8.sh,
        CustomDropList(
          list: filtrationBloc.qualified,
          hint: allTranslations.text(LocaleKeys.enter_qualification),
          onChanged: (value) {},
        ),
      ],
    );
  }
}
