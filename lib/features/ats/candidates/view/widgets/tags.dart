import 'package:eco_system/utility/export.dart';

class Tags extends StatelessWidget {
  final List<DropListModel> selectedTags;
  const Tags({super.key, required this.selectedTags});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltrationBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<FiltrationBloc>();
        final availableTags =
            bloc.tagsList.where((s) => !selectedTags.contains(s)).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(allTranslations.text(LocaleKeys.keyword),
                style: AppTextStyles.w400.copyWith(fontSize: 12)),
            8.sh,
            CustomDropDownSkills(
              hint: allTranslations.text(LocaleKeys.select_keywords),
              selectedList: selectedTags,
              onExpand: () => bloc.add(Expand()),
              isExpanded: bloc.filterModel.expandTags,
              onRemove: (item) {
                bloc.add(RemoveKeywords(arguments: item));
              },
            ),
            bloc.filterModel.expandTags
                ? _buildTagsList(context, availableTags,
                    onPickItem: (item) => bloc.add(PickTag(arguments: item)))
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}

Widget _buildTagsList(BuildContext context, List<DropListModel> list,
    {required void Function(DropListModel item) onPickItem}) {
  return Column(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
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
