import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

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
                style: context.textTheme.bodySmall),
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
          color: context.color.surfaceContainer,
          border: Border(
            bottom: BorderSide(color: context.color.outline),
            left: BorderSide(color: context.color.outline),
            right: BorderSide(color: context.color.outline),
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
                      ? Border(bottom: BorderSide(color: context.color.outline))
                      : null,
                ),
                child: Text(
                  item.name ?? "",
                  style: context.textTheme.bodySmall,
                ),
              ),
            );
          }),
        ),
      ),
    ],
  );
}
