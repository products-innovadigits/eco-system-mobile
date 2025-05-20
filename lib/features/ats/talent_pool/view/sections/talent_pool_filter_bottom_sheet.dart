import 'package:eco_system/utility/export.dart';

class TalentPoolFilterBottomSheet extends StatelessWidget {
  const TalentPoolFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltrationBloc, AppState>(
      builder: (context, state) {
        final filterBloc = context.read<FiltrationBloc>();
        final talentBloc = context.read<TalentPoolBloc>();

        final selectedTags = filterBloc.selectedTags;
        final availableTags = filterBloc.tagsList
            .where((s) => !selectedTags.contains(s))
            .toList();

        return Stack(
          children: [
            Column(
              children: [
                BottomSheetHeader(title: LocaleKeys.candidate),
                SizedBox(
                  height: context.h * 0.7,
                  child: ListView(
                    children: [
                      Text(allTranslations.text(LocaleKeys.skills),
                          style: AppTextStyles.w400.copyWith(fontSize: 12)),
                      8.sh,
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Styles.BORDER),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Wrap(
                                children: [
                                  TextField(
                                    controller: filterBloc.skillController,
                                    maxLines: 1,
                                    style: AppTextStyles.w400
                                        .copyWith(fontSize: 12),
                                    decoration: InputDecoration(
                                        hintText: allTranslations
                                            .text(LocaleKeys.add_skill),
                                        hintStyle: AppTextStyles.w400.copyWith(
                                            fontSize: 12, color: Styles.HINT),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8.h)),
                                  ),
                                  if (filterBloc.selectedSkills.isNotEmpty) ...[
                                    PickedChoicesList(
                                        list: filterBloc.selectedSkills,
                                        onRemove: (item) => filterBloc
                                            .add(RemoveSkill(arguments: item))),
                                    16.sw,
                                  ],
                                ],
                              ),
                            ),
                            Positioned.directional(
                              textDirection: TextDirection.ltr,
                              start: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  filterBloc.add(PickSkill(
                                      arguments: DropListModel(
                                          name: filterBloc
                                              .skillController.text)));
                                },
                                child: Padding(
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 8.w),
                                  child: Icon(Icons.add,
                                      color: Styles.PRIMARY_COLOR, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      16.sh,
                      Tags(),
                      filterBloc.expandTags
                          ? _buildOptionsList(context, availableTags,
                              onPickItem: (item) =>
                                  filterBloc.add(PickTag(arguments: item)))
                          : const SizedBox.shrink(),
                      16.sh,
                      ExpectedSalary(),
                      16.sh,
                      Experience(),
                      16.sh,
                      Location(),
                      16.sh,
                      Gender(),
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
                  onPressed: () {
                    talentBloc.add(ApplyFilters(arguments: {
                      "skills": filterBloc.selectedSkills,
                      "tags": filterBloc.selectedTags
                    }));
                    CustomNavigator.pop();
                  }),
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
