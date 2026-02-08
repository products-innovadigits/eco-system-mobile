import 'dart:developer';
import 'dart:math' as math;

import '../../../core/utility/project_management_exports.dart';
import 'project_monthly_progress/chart_widget.dart';
import 'project_monthly_progress/x_axis_widget.dart';
import 'project_monthly_progress/y_axis_widget.dart';

class ProjectMonthlyProgress extends StatefulWidget {
  const ProjectMonthlyProgress({
    super.key,
    required this.progressItems,
    this.currentMonth,
    this.isMonthly = true,
  });

  final List<ProgressItem> progressItems;
  final String? currentMonth;
  final bool isMonthly;

  @override
  State<ProjectMonthlyProgress> createState() => _ProjectMonthlyProgressState();
}

class _ProjectMonthlyProgressState extends State<ProjectMonthlyProgress> {
  late ScrollController _scrollController;
  late ScrollController _xAxisScrollController;
  bool _hasScrolled = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _xAxisScrollController = ScrollController();

    // Sync X-axis scroll with chart scroll
    _scrollController.addListener(_syncXAxisScroll);
    super.initState();
  }

  @override
  void didUpdateWidget(ProjectMonthlyProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset scroll flag if data or latestProgressItem changed
    if (oldWidget.progressItems != widget.progressItems ||
        oldWidget.currentMonth != widget.currentMonth) {
      _hasScrolled = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_syncXAxisScroll);
    _scrollController.dispose();
    _xAxisScrollController.dispose();
    super.dispose();
  }

  void _scrollToLatestProgress() {
    if (_hasScrolled ||
        !mounted ||
        widget.currentMonth == null ||
        widget.progressItems.isEmpty) {
      return;
    }

    // final String? widget.currentMonth = widget.currentMonth;
    if (widget.currentMonth == null) return;

    // Find the index of the data item that matches the latest progress period
    int? targetIndex;
    for (int i = 0; i < widget.progressItems.length; i++) {
      final String? dataName = widget.progressItems[i].month?.toString();
      if (dataName == null) continue;

      if (widget.currentMonth == dataName ||
          (int.tryParse(widget.currentMonth!)! > 5 &&
              dataName == widget.currentMonth)) {
        log(
          'Scrolling to index $i for period $widget.currentMonth matching name $dataName',
        );
        targetIndex = i;
        break;
      }
    }

    if (targetIndex != null && _scrollController.hasClients && mounted) {
      // First, ensure we start from the left (position 0) if not already there
      if (_scrollController.offset != 0) {
        _scrollController.jumpTo(0);
      }

      // Wait for the next frame to ensure the jump is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) return;

        final double screenWidth = MediaQuery.sizeOf(context).width;
        final double perPointWidth = 60.w;

        log(
          'Before scroll: targetIndex=$targetIndex, currentScrollPosition=${_scrollController.offset}, '
          'maxScrollExtent=${_scrollController.position.maxScrollExtent}',
        );

        // Calculate the position of the target point
        final double targetPointPosition = targetIndex! * perPointWidth;

        // To center the target point on screen
        final double targetScrollPosition =
            targetPointPosition + (perPointWidth / 2) - (screenWidth / 2);

        final double maxScroll = _scrollController.position.maxScrollExtent;
        final double scrollPosition = targetScrollPosition.clamp(
          0.0,
          maxScroll,
        );

        log(
          'Scrolling: targetIndex=$targetIndex, targetPointPosition=$targetPointPosition, '
          'targetScrollPosition=$targetScrollPosition, maxScroll=$maxScroll, '
          'finalScrollPosition=$scrollPosition',
        );

        _scrollController.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _hasScrolled = true;
      });
    }
  }

  // Sync X-axis scroll position with chart scroll position
  void _syncXAxisScroll() {
    if (_xAxisScrollController.hasClients && _scrollController.hasClients) {
      final offset = _scrollController.offset;
      if (_xAxisScrollController.offset != offset) {
        _xAxisScrollController.jumpTo(offset);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.progressItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double perPointWidth = 60.w;
    final double chartWidth = math.max(
      screenWidth,
      widget.progressItems.length * perPointWidth,
    );
    const double leftAxisReservedSize = 60;
    const double bottomAxisReservedSize = 30;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLatestProgress();
    });

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          // Chart body with fixed Y-axis
          SizedBox(
            height: 200.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Fixed Y-axis
                const SizedBox(
                  width: leftAxisReservedSize,
                  child: MonthlyProgressYAxis(),
                ),
                // Scrollable chart body
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: MonthlyProgressChart(
                      data: widget.progressItems,
                      chartWidth: chartWidth,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Fixed X-axis labels
          SizedBox(
            height: bottomAxisReservedSize,
            child: Row(
              children: [
                // Spacer for Y-axis alignment
                const SizedBox(width: leftAxisReservedSize),
                // Scrollable X-axis labels
                Expanded(
                  child: SingleChildScrollView(
                    controller: _xAxisScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    // Sync with chart scroll
                    child: SizedBox(
                      width: chartWidth,
                      child: MonthlyProgressXAxis(
                        data: widget.progressItems,
                        isMonthly: widget.isMonthly,
                        perPointWidth: perPointWidth,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
