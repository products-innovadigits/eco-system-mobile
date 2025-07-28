import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';
import 'package:strategy_package/bsc/widgets/strategic_categories_list.dart';

class StrategicAxesSection extends StatefulWidget {
  final bool isStrategicAxes;
  final List<StrategicAxisModel> axes;
  final int selectedAxes;

  const StrategicAxesSection({
    super.key,
    required this.axes,
    required this.selectedAxes,
    this.isStrategicAxes = false,
  });

  @override
  State<StrategicAxesSection> createState() => _StrategicAxesSectionState();
}

class _StrategicAxesSectionState extends State<StrategicAxesSection> {
  late int _selectedAxes;

  @override
  void initState() {
    _selectedAxes = widget.selectedAxes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isStrategicAxes
              ? allTranslations.text(LocaleKeys.strategic_axis)
              : allTranslations.text(LocaleKeys.strategic_results),
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        StrategicCategoriesList(
          axes: widget.axes,
          selectedAxes: _selectedAxes,
          onSelectAxes: (index) {
            setState(() {
              _selectedAxes = index;
            });
          },
        ),
        const SizedBox(height: 16),
        ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
          expansionAnimationStyle: AnimationStyle(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          ),
          title: Text(
            allTranslations.text(LocaleKeys.strategic_result),
            style: context.textTheme.labelMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: context.color.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: context.color.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          iconColor: context.color.secondary,
          collapsedIconColor: context.color.outlineVariant,
          collapsedTextColor: context.color.onSurface,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ).copyWith(bottom: 16.h),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  widget.axes[_selectedAxes].description ?? '',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.color.outlineVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
