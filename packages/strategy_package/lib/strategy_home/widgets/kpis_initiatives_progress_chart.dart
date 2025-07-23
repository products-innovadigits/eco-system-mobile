import 'package:core_package/core/utility/export.dart';
import 'package:intl/intl.dart';
import 'package:strategy_package/strategy_home/model/kpis_initiatives_progress_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class KpisInitiativesProgressChart extends StatelessWidget {
  final List<KpisInitiativesProgressModel> data;

  const KpisInitiativesProgressChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
      format: 'point.y',
      textStyle: context.textTheme.labelMedium?.copyWith(
        color: LightColor.white,
        fontWeight: FontWeight.w600,
      ),
      color: context.color.primary,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: (data.length == 1) ? 300.w : context.w,
        height: 285.h,
        child: SfCartesianChart(
          tooltipBehavior: tooltipBehavior,
          // legend: Legend(
          //   isVisible: true,
          //   position: LegendPosition.bottom,
          //   overflowMode: LegendItemOverflowMode.wrap,
          // ),
          primaryXAxis: CategoryAxis(
            majorGridLines: MajorGridLines(width: 0),
            labelStyle: context.textTheme.bodySmall?.copyWith(
              color: context.color.outlineVariant,
              fontSize: 10,
            ),
            axisLine: AxisLine(width: 1, color: context.color.outline),
            majorTickLines: MajorTickLines(size: 1),
            isInversed: true
            // autoScrollingMode: AutoScrollingMode.end,
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 100,
            interval: 20,
            numberFormat: NumberFormat("##'%'"),
            labelStyle: context.textTheme.bodySmall?.copyWith(
              color: context.color.outlineVariant,
              fontSize: 10,
            ),
            axisLine: AxisLine(width: 1, color: context.color.outline),
            majorTickLines: MajorTickLines(size: 0),
            opposedPosition: true,
          ),
          series: [
            StackedColumnSeries<KpisInitiativesProgressModel, String>(
              dataSource: data,
              xValueMapper: (m, _) => m.objective.toString(),
              yValueMapper: (m, _) => m.kpisValue,
              color: context.color.primary,
              width: 0.1,
              borderRadius: BorderRadius.circular(12),
              borderColor: LightColor.white,
              animationDuration: 800,
              // pointWidth: 12,
            ),
            StackedColumnSeries<KpisInitiativesProgressModel, String>(
              dataSource: data,
              xValueMapper: (m, _) => m.objective.toString(),
              yValueMapper: (m, _) => m.initiativesValue,
              color: Color(0xff0C9A84),
              // color: context.color.tertiary,
              width: 0.1,
              borderRadius: BorderRadius.circular(12),
              borderColor: LightColor.white,
              animationDuration: 800,
              // pointWidth: 12,
            ),
          ],
        ),
      ),
    );
  }
}
