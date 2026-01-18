import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class ExpectedSalary extends StatelessWidget {
  const ExpectedSalary({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<AtsFiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          allTranslations.text(LocaleKeys.expected_salary),
          style: context.textTheme.bodySmall,
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hint: allTranslations.text(LocaleKeys.from),
                controller: filtrationBloc.expectedSalaryFromController,
                type: TextInputType.number,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: CustomTextField(
                hint: allTranslations.text(LocaleKeys.to),
                controller: filtrationBloc.expectedSalaryToController,
                type: TextInputType.number,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: CustomDropList(
                list: filtrationBloc.currencies,
                hint: filtrationBloc.currencyController.text.isEmpty
                    ? allTranslations.text(LocaleKeys.currency)
                    : filtrationBloc.currencyController.text,
                onChanged: (value) {
                  filtrationBloc.currencyController.text = value.name ?? '';
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
