import 'package:core_system/core/modules/system_module.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/app/modules/modules_registry.dart';

/// Tappable field that opens a bottom sheet to pick multiple enabled systems.
class MultiSelectSystemsField extends StatelessWidget {
  final Set<String> selectedModuleIds;
  final ValueChanged<Set<String>> onChanged;

  const MultiSelectSystemsField({
    super.key,
    required this.selectedModuleIds,
    required this.onChanged,
  });

  void _openSheet(BuildContext context) {
    final modules = ModulesRegistry.enabledModules;
    var draft = Set<String>.from(selectedModuleIds);

    PopUpHelper.showBottomSheet(
      header: allTranslations.text(LocaleKeys.login_pick_systems),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          void toggle(String id) {
            setModalState(() {
              if (draft.contains(id)) {
                draft.remove(id);
              } else {
                draft.add(id);
              }
            });
          }

          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...List.generate(modules.length, (index) {
                  final SystemModule m = modules[index];
                  final selected = draft.contains(m.id);
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < modules.length - 1 ? 10.h : 0,
                    ),
                    child: Material(
                      color: selected
                          ? context.color.secondary.withValues(alpha: 0.08)
                          : context.color.surfaceContainer.withValues(
                              alpha: 0.35,
                            ),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => toggle(m.id),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: selected,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (_) => toggle(m.id),
                                  activeColor: context.color.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Text(
                                  m.name,
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 20.h),
                CustomBtn(
                  text: allTranslations.text(LocaleKeys.done),
                  onPressed: () {
                    onChanged(Set<String>.from(draft));
                    CustomNavigator.pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = selectedModuleIds.length;
    final label = count == 0
        ? allTranslations.text(LocaleKeys.login_select_systems_hint)
        : '$count ${allTranslations.text(LocaleKeys.login_pick_systems)}';

    return InkWell(
      onTap: () => _openSheet(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.color.outline),
          color: LightColor.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.w400.copyWith(
                  fontSize: 12,
                  color: count == 0 ? Styles.hint : Styles.header,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Images(image: Assets.svgs.arrowDown.path),
          ],
        ),
      ),
    );
  }
}
