import 'package:project_management/core/utility/project_management_exports.dart';

class MonthlyAnnualChartFilterWidget extends StatelessWidget {
  final Function(ChartTime time) onSelect;
  final ChartTime selectedTime;

  const MonthlyAnnualChartFilterWidget({
    super.key,
    required this.onSelect,
    this.selectedTime = ChartTime.monthly,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: context.color.secondary.withValues(alpha: 0.2),
      ),
      child: PopupMenuButton<ChartTime>(
        initialValue: selectedTime,
        onSelected: (ChartTime time) {
          onSelect(time);
        },
        itemBuilder: (BuildContext ctx) {
          return ChartTime.values.map((ChartTime time) {
            return PopupMenuItem<ChartTime>(
              value: time,
              child: Text(
                allTranslations.text(time.name),
                style: context.textTheme.labelSmall,
              ),
            );
          }).toList();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: context.color.surfaceContainer,
            border: Border.all(color: context.color.outline),
          ),
          child: Row(
            children: [
              Text(
                allTranslations.text(selectedTime.name),
                style: context.textTheme.bodySmall,
              ),
              SizedBox(width: 8.w),
              Images(image: Assets.svgs.arrowDown.path, width: 6, height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
