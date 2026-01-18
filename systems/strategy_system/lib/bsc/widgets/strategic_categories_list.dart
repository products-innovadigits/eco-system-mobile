import '../../shared/strategy_exports.dart';

class StrategicCategoriesList extends StatelessWidget {
  final List<StrategicAxisModel> axes;
  final int selectedAxes;
  final ValueChanged<int> onSelectAxes;

  const StrategicCategoriesList({
    super.key,
    required this.axes,
    required this.selectedAxes,
    required this.onSelectAxes,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: axes.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          return _strategicAxisChip(
            context,
            title: axes[index].title ?? '',
            color: axes[index].colorCode ?? '#175CD3',
            isSelected: selectedAxes == index,
            onTap: () => onSelectAxes(index),
          );
        },
      ),
    );
  }
}

Widget _strategicAxisChip(
  BuildContext context, {
  required String title,
  required String color,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  final Color strategicColor = Color(
    int.parse(color.replaceFirst('#', '0xff')),
  );
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: isSelected
            ? strategicColor // context.color.primaryContainer
            : context.color.surfaceContainer,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: isSelected
              ? strategicColor
              : context.color.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Text(
          title,
          style: context.textTheme.labelSmall?.copyWith(
            color: isSelected ? context.color.onPrimary : strategicColor,
          ),
        ),
      ),
    ),
  );
}
