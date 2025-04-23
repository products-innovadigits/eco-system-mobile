import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/features/ats/candidates/bloc/candidates_bloc.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.gen.dart'; // update path

class CustomDropDownSkills extends StatelessWidget {
  final String? hint;

  const CustomDropDownSkills({
    super.key,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidatesBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<CandidatesBloc>();
        final selected = bloc.selectedSkills;
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Styles.BORDER),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: selected.isEmpty
                        ? Text(
                            hint ?? allTranslations.text('select_skills'),
                            style: AppTextStyles.w400
                                .copyWith(fontSize: 12, color: Styles.HINT),
                          )
                        : _buildPickedWrap(context, bloc),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => bloc.add(ExpandSkills()),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: 24,
                      height: 24,
                      child: Images(image: Assets.svgs.arrowDown.path),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPickedWrap(BuildContext context, CandidatesBloc bloc) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      runSpacing: 12,
      children: bloc.selectedSkills.map((item) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Styles.PRIMARY_COLOR.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.name ?? "",
                style: AppTextStyles.w400.copyWith(
                  fontSize: 10,
                  color: Styles.PRIMARY_COLOR,
                ),
              ),
              4.sw,
              InkWell(
                onTap: () => bloc.add(RemoveSkill(arguments: item)),
                child: Images(
                  image: Assets.svgs.fillCloseCircle.path,
                  color: Styles.PRIMARY_COLOR,
                  width: 18,
                  height: 18,
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
