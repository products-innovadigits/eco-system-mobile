

import 'package:core_package/core/helpers/font_sizes.dart';

import '../../shared/strategy_exports.dart';

class ObjectiveDetailsChart extends StatefulWidget {
  const ObjectiveDetailsChart({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<ObjectiveDetailsChart> createState() => _ObjectiveDetailsChartState();
}

class _ObjectiveDetailsChartState extends State<ObjectiveDetailsChart> {
  ChartTime currentTime = ChartTime.Month;

  scrollToBottom() {
    Future.delayed(Duration(microseconds: 500), () {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          border: Border.all(color: context.color.outline),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  allTranslations.text(LocaleKeys.kpis_general_progress),
                  style: context.textTheme.titleLarge?.copyWith(fontSize: FontSizes.f14),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                  children: List.generate(
                ChartTime.values.length,
                (i) => InkWell(
                  onTap: () => setState(() {
                    currentTime = ChartTime.values[i];
                    scrollToBottom();
                  }),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: currentTime == ChartTime.values[i]
                          ? context.color.primary
                          : context.color.secondary.withValues(alpha: 0.1),
                    ),
                    child: Text(
                      allTranslations.text(ChartTime.values[i].name),
                      style:context.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: currentTime == ChartTime.values[i]
                            ? context.color.onPrimary
                            : context.color.primary,
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: context.color.outline),
          ),
          currentTime == ChartTime.Month
              ? ObjectiveBarMonthlyChart()
              : ObjectiveLineAnnualChart(),
        ],
      ),
    );
  }
}
