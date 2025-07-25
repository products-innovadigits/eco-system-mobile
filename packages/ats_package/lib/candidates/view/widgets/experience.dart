import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class Experience extends StatelessWidget {
  const Experience({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<FiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.experience),
            style: AppTextStyles.w400.copyWith(fontSize: 12)),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hint: allTranslations.text(LocaleKeys.from),
                controller: filtrationBloc.experienceFromController,
                type: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            4.sw,
            Expanded(
              child: CustomTextField(
                hint: allTranslations.text(LocaleKeys.to),
                controller: filtrationBloc.experienceToController,
                type: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
