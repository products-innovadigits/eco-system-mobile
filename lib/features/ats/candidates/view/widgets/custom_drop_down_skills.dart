import 'package:eco_system/features/ats/candidates/view/sections/picked_choices_list.dart';
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
          onTap: onExpand,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                              allTranslations.text(LocaleKeys.select_skills),
                          style: AppTextStyles.w400
                              .copyWith(fontSize: 12, color: Styles.HINT),
                        )
                      : PickedChoicesList(
                          list: selectedList, onRemove: onRemove),
                ),
                const SizedBox(width: 12),
                // Right side: Dropdown arrow button
                InkWell(
                  onTap: onExpand,
                  child: Container(
                    padding: EdgeInsets.all(5.w),
                    width: 24.w,
                    height: 24.w,
                    child: Images(
                      image: Assets.svgs.arrowDown.path,
                      // Added visual feedback: arrow changes color when expanded
                      color: isExpanded ? Styles.PRIMARY_COLOR : null,
                    ),
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
