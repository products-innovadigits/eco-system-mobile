import 'package:eco_system/utility/export.dart';

class CandidatesFilterBottomSheet extends StatelessWidget {
  final bool isTalentPool;

  const CandidatesFilterBottomSheet({super.key, this.isTalentPool = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltrationBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<FiltrationBloc>();
        final selectedSkills = bloc.selectedSkills;
        final selectedKeywords = bloc.selectedKeywords;
        final availableSkills =
            bloc.skills.where((s) => !selectedSkills.contains(s)).toList();
        final availableKeywords =
            bloc.keywords.where((s) => !selectedKeywords.contains(s)).toList();
        return Stack(
          children: [
            Column(
              children: [
                BottomSheetHeader(title: LocaleKeys.candidate),
                24.sh,
                SizedBox(
                  height: isTalentPool ? context.h * 0.65 : context.h * 0.8,
                  child: ListView(
                    children: [
                      Skills(),
                      bloc.expandSkills
                          ? _buildOptionsList(context, availableSkills,
                              onPickItem: (item) =>
                                  bloc.add(PickSkill(arguments: item)))
                          : const SizedBox.shrink(),
                      if (!isTalentPool) ...[
                        16.sh,
                        Keywords(),
                        bloc.expandKeywords
                            ? _buildOptionsList(context, availableKeywords,
                                onPickItem: (item) =>
                                    bloc.add(PickKeyword(arguments: item)))
                            : const SizedBox.shrink(),
                      ],
                      16.sh,
                      ExpectedSalary(),
                      16.sh,
                      Experience(),
                      16.sh,
                      Location(),
                      16.sh,
                      Gender(),
                      if (!isTalentPool) ...[
                        16.sh,
                        Qualified(),
                        16.sh,
                        ApplicationDate(),
                        16.sh,
                        CompatibilityRate(),
                      ],
                      60.sh
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: CustomBtn(
                  width: context.w * 0.9,
                  text: allTranslations.text(LocaleKeys.show_all_results),
                  onPressed: () => CustomNavigator.pop()),
            )
          ],
        );
      },
    );
  }
}

Widget _buildOptionsList(BuildContext context, List<DropListModel> list,
    {required void Function(DropListModel item) onPickItem}) {
  return Column(
    children: [
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
              onTap: () => onPickItem(item),
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
