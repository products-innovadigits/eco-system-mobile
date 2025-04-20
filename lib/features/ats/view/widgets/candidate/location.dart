import 'package:eco_system/components/custom_text_field.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/bloc/candidates_bloc.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Location extends StatelessWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.location),
            style: AppTextStyles.w400.copyWith(fontSize: 12)),
        CustomTextField(
          hint: allTranslations.text(LocaleKeys.enter_your_location),
          controller:
          context.read<CandidatesBloc>().locationController,
        ),
      ],
    );;
  }
}
