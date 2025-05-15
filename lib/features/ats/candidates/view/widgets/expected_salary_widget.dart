import 'package:eco_system/components/custom_drop_list.dart';
import 'package:eco_system/components/custom_text_field.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/bloc/filtration_bloc.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpectedSalary extends StatelessWidget {
  const ExpectedSalary({super.key});

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
                hint: allTranslations.text(LocaleKeys.currency),
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
