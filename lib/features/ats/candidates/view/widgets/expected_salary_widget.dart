import 'package:eco_system/utility/export.dart';

class ExpectedSalary extends StatelessWidget {
  final String? expectedSalaryFrom;
  final String? expectedSalaryTo;
  final String? currency;

  const ExpectedSalary(
      {super.key,
      this.expectedSalaryFrom,
      this.expectedSalaryTo,
      this.currency});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<FiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.expected_salary),
            style: AppTextStyles.w400.copyWith(fontSize: 12)),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hint: allTranslations.text(LocaleKeys.from),
                controller: filtrationBloc.expectedSalaryFromController,
                type: TextInputType.number,
              ),
            ),
            4.sw,
            Expanded(
              child: CustomTextField(
                hint: allTranslations.text(LocaleKeys.to),
                controller: filtrationBloc.expectedSalaryToController,
                type: TextInputType.number,
              ),
            ),
            4.sw,
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
