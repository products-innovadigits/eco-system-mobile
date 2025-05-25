import 'package:eco_system/features/ats/candidates/view/sections/picked_choices_list.dart';
import 'package:eco_system/utility/export.dart';

/// A custom dropdown widget for selecting skills or tags.
/// Features:
/// - Toggleable dropdown list
/// - Visual feedback for expanded state
/// - Support for selected items with remove functionality
/// - Customizable hint text
class CustomDropDownSkills extends StatelessWidget {
  /// Hint text to display when no items are selected
  final String? hint;

  /// List of currently selected items
  final List<DropListModel> selectedList;

  /// Callback function triggered when dropdown is toggled
  final VoidCallback onExpand;

  /// Current state of the dropdown (expanded/collapsed)
  final bool isExpanded;

  /// Callback function for removing selected items
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
        // Main container that acts as the dropdown trigger
        InkWell(
          // Allow toggling by tapping anywhere on the container
          onTap: onExpand,
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
                // Left side: Either shows hint text or selected items
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
                  // Allow toggling by tapping the arrow
                  onTap: onExpand,
                  child: Container(
                    padding: const EdgeInsets.all(5),
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
