
import 'package:core_system/core/utility/export.dart';
import 'package:pms_system/pms_home/model/kpis_initiatives_progress_model.dart';

class MonthlyAnnualChartFilterWidget extends StatefulWidget {
  final Function(ChartTime time) onSelect;

  const MonthlyAnnualChartFilterWidget({super.key, required this.onSelect});

  @override
  State<MonthlyAnnualChartFilterWidget> createState() =>
      _MonthlyAnnualChartFilterWidgetState();
}

class _MonthlyAnnualChartFilterWidgetState
    extends State<MonthlyAnnualChartFilterWidget> {
  ChartTime currentTime = ChartTime.Month;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: context.color.secondary.withValues(alpha: 0.2),
      ),
      child: PopupMenuButton<ChartTime>(
        initialValue: currentTime,
        onSelected: (ChartTime time) {
          setState(() => currentTime = time);
          widget.onSelect(time).call;
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
                allTranslations.text(currentTime.name),
                style: context.textTheme.bodySmall,
              ),
              8.sw,
              Images(image: Assets.svgs.arrowDown.path, width: 6, height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
