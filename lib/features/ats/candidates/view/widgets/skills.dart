import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/bloc/filtration_bloc.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/custom_drop_down_skills.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Skills extends StatelessWidget {
  const Skills({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltrationBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<FiltrationBloc>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(allTranslations.text(LocaleKeys.skills),
                style: AppTextStyles.w400.copyWith(fontSize: 12)),
            8.sh,
            CustomDropDownSkills(
              hint: allTranslations.text(LocaleKeys.select_skills),
              selectedList: bloc.selectedSkills,
              onExpand: () => bloc.add(ExpandSkills()),
              isExpanded: bloc.expandSkills,
              onRemove: (item) {
                bloc.add(RemoveSkill(arguments: item));
              },
            ),
          ],
        );
      },
    );
  }
}
