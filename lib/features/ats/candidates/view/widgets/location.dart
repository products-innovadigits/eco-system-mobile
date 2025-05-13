import 'package:eco_system/components/custom_drop_list.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/bloc/filtration_bloc.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Location extends StatelessWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationBloc = context.read<FiltrationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(allTranslations.text(LocaleKeys.location),
            style: AppTextStyles.w400.copyWith(fontSize: 12)),
        8.sh,
        CustomDropList(
          list: filtrationBloc.locations,
          hint: allTranslations.text(LocaleKeys.select_your_location),
          onChanged: (value){},
        ),
        // CustomTextField(
        //   hint: allTranslations.text(LocaleKeys.enter_your_location),
        //   controller:
        //   context.read<CandidatesBloc>().locationController,
        //  isReadOnly: true,
        //  onTap: (){
        //
        //  },
        // ),
      ],
    );;
  }
}
