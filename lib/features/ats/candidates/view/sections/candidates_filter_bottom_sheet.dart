import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/components/custom_drop_list.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/candidates/bloc/candidates_bloc.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/expected_salary_widget.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/experience.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/gender.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/location.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/skills_widget.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidatesFilterBottomSheet extends StatelessWidget {
  const CandidatesFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidatesBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<CandidatesBloc>();
        final selected = bloc.selectedSkills;
        final available =
            bloc.skills.where((s) => !selected.contains(s)).toList();
        return Stack(
          children: [
            Column(
              children: [
                BottomSheetHeader(title: LocaleKeys.candidate, onReset: () {}),
                24.sh,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.h,
                  children: [
                    Skills(),
                    ExpectedSalary(),
                    Experience(),
                    Location(),
                    Gender(),
                    50.sh
                  ],
                ),
              ],
            ),
            bloc.expandSkills
                ? _buildOptionsList(context, available, bloc)
                : const SizedBox.shrink(),
            Positioned(
              bottom: 0,
              child: CustomBtn(
                  width: context.w * 0.9,
                  text: allTranslations.text(LocaleKeys.show_all_results),
                  onPressed: () {}),
            )
          ],
        );
      },
    );
  }
}

Widget _buildOptionsList(
    BuildContext context, List<DropListModel> list, CandidatesBloc bloc) {
  return Column(
    children: [
      120.sh,
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Styles.BORDER),
            left: BorderSide(color: Styles.BORDER),
            right: BorderSide(color: Styles.BORDER),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(list.length, (index) {
            final item = list[index];
            return GestureDetector(
              onTap: () => bloc.add(PickSkill(arguments: item)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: index != list.length - 1
                      ? Border(bottom: BorderSide(color: Styles.BORDER))
                      : null,
                ),
                child: Text(
                  item.name ?? "",
                  style: AppTextStyles.w400.copyWith(
                    color: Styles.TEXT_COLOR,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    ],
  );
}
