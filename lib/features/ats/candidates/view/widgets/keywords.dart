import 'package:eco_system/utility/export.dart';

class Keywords extends StatelessWidget {
  const Keywords({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltrationBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<FiltrationBloc>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(allTranslations.text(LocaleKeys.keyword),
                style: AppTextStyles.w400.copyWith(fontSize: 12)),
            8.sh,
            CustomDropDownSkills(
              hint: allTranslations.text(LocaleKeys.select_keywords),
              selectedList: bloc.selectedKeywords,
              onExpand: () => bloc.add(ExpandKeywords()),
              isExpanded: bloc.expandKeywords,
              onRemove: (item) {
                bloc.add(RemoveKeywords(arguments: item));
              },
            ),
          ],
        );
      },
    );
  }
}
