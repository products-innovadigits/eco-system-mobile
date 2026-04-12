import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/bsc/model/bsc_model.dart';
import 'package:strategy_system/bsc/widgets/strategic_categories_list.dart';

class StrategicAxesSection extends StatefulWidget {
  final bool isStrategicAxes;
  /// Axes from the API (e.g. [VisionDataModel.strategicAxises]).
  final List<StrategicAxisModel> axes;
  /// When [axes] is empty, these demo axes are shown so chips / «النتيجة الاستراتيجية»
  /// stay aligned with [StrategicAxesView] + [resolveStrategicAxisObjectives] fallbacks.
  final List<StrategicAxisModel>? axesDemoWhenEmpty;
  final int selectedAxes;
  /// Notifies parent when the user selects another axis (e.g. to refresh linked objectives).
  final ValueChanged<int>? onAxisIndexChanged;

  const StrategicAxesSection({
    super.key,
    required this.axes,
    required this.selectedAxes,
    this.isStrategicAxes = false,
    this.axesDemoWhenEmpty,
    this.onAxisIndexChanged,
  });

  @override
  State<StrategicAxesSection> createState() => _StrategicAxesSectionState();
}

class _StrategicAxesSectionState extends State<StrategicAxesSection> {
  late int _selectedAxes;

  List<StrategicAxisModel> get _effectiveAxes {
    if (widget.axes.isNotEmpty) return widget.axes;
    return widget.axesDemoWhenEmpty ?? const [];
  }

  @override
  void initState() {
    _selectedAxes = widget.selectedAxes;
    super.initState();
  }

  @override
  void didUpdateWidget(StrategicAxesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedAxes != oldWidget.selectedAxes) {
      _selectedAxes = widget.selectedAxes;
    }
  }

  int get _safeAxisIndex {
    final n = _effectiveAxes.length;
    if (n == 0) return 0;
    if (_selectedAxes < 0) return 0;
    if (_selectedAxes >= n) return n - 1;
    return _selectedAxes;
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
          axes: _effectiveAxes,
          selectedAxes: _safeAxisIndex,
          onSelectAxes: (index) {
            setState(() {
              _selectedAxes = index;
            });
            widget.onAxisIndexChanged?.call(index);
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
                  _effectiveAxes.isEmpty
                      ? ''
                      : (_effectiveAxes[_safeAxisIndex].description ?? ''),
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
