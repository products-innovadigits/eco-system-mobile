import 'package:eco_system/components/custom_drop_list.dart';
import 'package:eco_system/components/custom_text_field.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/candidates/bloc/candidates_bloc.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpectedSalary extends StatelessWidget {
  const ExpectedSalary({super.key});

  @override
  Widget build(BuildContext context) {
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
                controller:
                    context.read<CandidatesBloc>().expectedSalaryFromController,
              ),
            ),
            4.sw,
            Expanded(
              child: CustomTextField(
                hint: allTranslations.text(LocaleKeys.to),
                controller:
                    context.read<CandidatesBloc>().expectedSalaryToController,
              ),
            ),
            4.sw,
            Expanded(
              child: CustomDropList(
                list: context.read<CandidatesBloc>().currencies,
                hint: allTranslations.text(LocaleKeys.currency),
                onChanged: (value){},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
