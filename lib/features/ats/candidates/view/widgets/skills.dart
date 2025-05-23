import 'package:eco_system/utility/export.dart';

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
