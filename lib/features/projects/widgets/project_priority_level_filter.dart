import 'package:eco_system/features/projects/bloc/project_priority_level_bloc.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/model/custom_field_model.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/animated_widget.dart';
import '../../../components/confirm_bottom_sheet.dart';
import '../../../core/app_core.dart';
import '../../../core/app_event.dart';
import '../../../core/app_notification.dart';
import '../../../core/app_state.dart';
import '../../../helpers/styles.dart';
import '../../../helpers/text_styles.dart';
import '../../../navigation/custom_navigation.dart';

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
                border: Border.all(
                  color: Styles.LIGHT_GREY_BORDER,
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
                      style: AppTextStyles.w400.copyWith(
                          fontSize: 14,
                          color: initialSelection != null
                              ? Styles.HEADER
                              : Styles.HINT),
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
                  ? Styles.PRIMARY_COLOR
                  : Styles.WHITE_COLOR,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: _selectedItem?.id == widget.list[index].id
                      ? Styles.WHITE_COLOR
                      : Styles.PRIMARY_COLOR),
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
                          ? Styles.WHITE_COLOR
                          : Styles.PRIMARY_COLOR,
                    ),
                  ),
                ),
                Icon(
                    _selectedItem?.id == widget.list[index].id
                        ? Icons.radio_button_checked_outlined
                        : Icons.radio_button_off,
                    size: 22,
                    color: _selectedItem?.id == widget.list[index].id
                        ? Styles.WHITE_COLOR
                        : Styles.PRIMARY_COLOR)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
