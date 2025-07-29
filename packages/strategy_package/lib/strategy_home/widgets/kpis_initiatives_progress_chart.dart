import 'package:core_package/core/utility/export.dart';
import 'package:intl/intl.dart';
import 'package:strategy_package/strategy_home/model/kpis_initiatives_progress_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class ObjectivesKpisInitiativesChart extends StatelessWidget {
  final List<KpisInitiativesProgressModel> data;
  const ObjectivesKpisInitiativesChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double _targetBarPx = data.length > 1 ? 62 : 90;
        double _minSeriesWidth = data.length > 1 ? 0.13 : 0.20;
        double _maxSeriesWidth = data.length > 1 ? 0.5 : 0.8;
        final double plotWidth = constraints.maxWidth;
        double seriesWidth =
            (data.length * _targetBarPx) / plotWidth;
        seriesWidth = seriesWidth.clamp(_minSeriesWidth, _maxSeriesWidth);
        return SfCartesianChart(
          tooltipBehavior: _tooltip,
          zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true, zoomMode: ZoomMode.x),
          primaryXAxis: CategoryAxis(
            isInversed: true,
            autoScrollingDelta: 4,
            autoScrollingMode: AutoScrollingMode.end,
            interval: 1,
            labelIntersectAction: AxisLabelIntersectAction.wrap,
            maximumLabelWidth: 200,
            axisLine: AxisLine(width: 1, color: context.color.outline),
            labelStyle: context.textTheme.bodySmall?.copyWith(
              color: context.color.outlineVariant,
              fontSize: 10,
            ),
          ),
          primaryYAxis: NumericAxis(
            minimum: 0, maximum: 100, interval: 20,
            opposedPosition: true, numberFormat: NumberFormat("##'%'"),
            axisLine: AxisLine(width: 1, color: context.color.outline),
            labelStyle: context.textTheme.bodySmall?.copyWith(
                color: context.color.outlineVariant, fontSize: 10),
            majorTickLines: const MajorTickLines(size: 0),
          ),
          series: [
            StackedColumnSeries<KpisInitiativesProgressModel, String>(
              dataSource: data,
              enableTooltip: false,
              xValueMapper: (m, _) => m.objective,
              yValueMapper: (m, _) => m.kpisValue,
              color: context.color.primary,
              width: seriesWidth,       // ➎ adaptive!
              spacing: 1 - seriesWidth, // keep slot fully used
              borderRadius: BorderRadius.circular(16),
              borderColor: LightColor.white,
            ),
            StackedColumnSeries<KpisInitiativesProgressModel, String>(
              dataSource: data,
              xValueMapper: (m, _) => m.objective,
              yValueMapper: (m, _) => m.initiativesValue,
              color: const Color(0xff0C9A84),
              width: seriesWidth,
              spacing: 1 - seriesWidth,
              borderRadius: BorderRadius.circular(16),
              borderColor: LightColor.white,
            ),
          ],
        );
      },
    );
  }
}

final TooltipBehavior _tooltip = TooltipBehavior(
  enable: true,
  header: '',
  canShowMarker: false,
  tooltipPosition: TooltipPosition.pointer,
  color: const Color(0xFF0C9A84),
  builder: (
      dynamic data, dynamic point, dynamic series,
      int pointIndex, int seriesIndex,
      ) {
    final m = data as KpisInitiativesProgressModel;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0C9A84),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${allTranslations.text(LocaleKeys.objective)} '
              '${m.objectiveValue}%',
              style: const TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${m.initiativesValue}% '
                  '${allTranslations.text(LocaleKeys.initiative)}',
                  style: const TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
              const SizedBox(width: 8),
              Text('${m.kpisValue}% '
                  '${allTranslations.text(LocaleKeys.kpi)}',
                  style: const TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  },
);
