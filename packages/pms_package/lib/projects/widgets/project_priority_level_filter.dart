
import 'package:pms_package/shared/pms_exports.dart';

class ProjectPriorityFilter extends StatelessWidget {
  const ProjectPriorityFilter(
      {super.key, this.onSelect, this.initialSelection});
  final Function(CustomFieldModel?)? onSelect;
  final CustomFieldModel? initialSelection;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectPriorityLevelBloc()..add(Click()),
      child: BlocBuilder<ProjectPriorityLevelBloc, AppState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              if (state is Done) {
                List<CustomFieldModel> list =
                    state.list as List<CustomFieldModel>;
                CustomBottomSheet.show(
                  label: allTranslations.text("select_priority_level"),
                  onConfirm: () => CustomNavigator.pop(),
                  onCancel: () {
                    onSelect?.call(null);
                  },
                  widget: _SelectionView(
                    list: list,
                    initialValue: initialSelection,
                    onConfirm: (v) => onSelect?.call(v),
                  ),
                );
              }
              if (state is Loading) {
                AppCore.showSnackBar(
                    notification: AppNotification(
                  message: allTranslations.text("loading"),
                  backgroundColor: Styles.PENDING,
                ));
              }
              if (state is Empty) {
                AppCore.showSnackBar(
                    notification: AppNotification(
                  message: allTranslations.text("there_is_priority_levels"),
                  backgroundColor: Styles.PENDING,
                ));
              }
              if (state is Error) {
                AppCore.errorMessage(
                  allTranslations.text("something_went_wrong"),
                );
              }
            },
            child: Container(
              height: 45.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: context.color.surfaceContainer,
                border: Border.all(
                  color: context.color.outline,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      initialSelection?.name ?? allTranslations.text("all"),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: context.textTheme.bodyMedium?.copyWith(
                          color: initialSelection != null
                              ? context.color.primary
                              : context.color.outlineVariant),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 24,
                    color: Styles.HINT,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SelectionView extends StatefulWidget {
  const _SelectionView(
      {required this.onConfirm, required this.list, this.initialValue});
  final ValueChanged<CustomFieldModel> onConfirm;
  final List<CustomFieldModel> list;
  final CustomFieldModel? initialValue;

  @override
  State<_SelectionView> createState() => _SelectionViewState();
}

class _SelectionViewState extends State<_SelectionView> {
  CustomFieldModel? _selectedItem;
  @override
  void initState() {
    setState(() {
      if (widget.initialValue != null) {
        _selectedItem = widget.initialValue;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListAnimator(
      customPadding: EdgeInsets.symmetric(horizontal: 18.w),
      data: List.generate(
        widget.list.length,
        (index) => GestureDetector(
          onTap: () {
            setState(() => _selectedItem = widget.list[index]);
            widget.onConfirm(widget.list[index]);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: _selectedItem?.id == widget.list[index].id
                  ? context.color.primary
                  : context.color.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: _selectedItem?.id == widget.list[index].id
                      ? context.color.surfaceContainer
                      : context.color.primary),
            ),
            width: context.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.list[index].name ?? "",
                    style: AppTextStyles.w600.copyWith(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      color: _selectedItem?.id == widget.list[index].id
                          ? context.color.surfaceContainer
                          : context.color.primary,
                    ),
                  ),
                ),
                Icon(
                    _selectedItem?.id == widget.list[index].id
                        ? Icons.radio_button_checked_outlined
                        : Icons.radio_button_off,
                    size: 22,
                    color: _selectedItem?.id == widget.list[index].id
                        ? context.color.surfaceContainer
                        : context.color.primary)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
