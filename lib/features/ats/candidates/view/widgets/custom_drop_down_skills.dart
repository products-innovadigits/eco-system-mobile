import 'package:eco_system/utility/export.dart';

class CustomDropDownSkills extends StatelessWidget {
  final String? hint;
  final List<DropListModel> selectedList;
  final VoidCallback onExpand;
  final bool isExpanded;
  final void Function(DropListModel item) onRemove;

  const CustomDropDownSkills({
    super.key,
    this.hint,
    required this.selectedList,
    required this.onExpand,
    required this.onRemove,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (selectedList.isEmpty) onExpand();
          },
          child: Container(
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
                  child: selectedList.isEmpty
                      ? Text(
                          hint ??
                              allTranslations
                                  .text(LocaleKeys.select_skills),
                          style: AppTextStyles.w400
                              .copyWith(fontSize: 12, color: Styles.HINT),
                        )
                      : PickedChoicesList(
                          list: selectedList, onRemove: onRemove),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    if (!isExpanded) onExpand();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 24.w,
                    height: 24.w,
                    child: Images(image: Assets.svgs.arrowDown.path),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
