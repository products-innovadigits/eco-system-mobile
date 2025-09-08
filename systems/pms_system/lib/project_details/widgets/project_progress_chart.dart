import 'package:pms_system/shared/pms_exports.dart';

class ProjectProgressChart extends StatelessWidget {
  const ProjectProgressChart({
    super.key,
    required this.data,
  });

  final List<ProjectProgressItemModel> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const EmptyContainer();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bars
        ...data.map((item) => _buildProgressRow(context, item)),

        16.sh,

        // Bottom X-axis progress indicators
        _buildBottomProgressIndicators(context),
      ],
    );
  }

  Widget _buildProgressRow(BuildContext context, ProjectProgressItemModel item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        children: [
          // Label section
          Expanded(
            flex: 3,
            child: Text(
              allTranslations.text(item.titleKey),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.right,
            ),
          ),


          // Progress bar section
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bar
                Container(
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: context.color.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Stack(
                    children: [
                      // Progress fill
                      FractionallySizedBox(
                        widthFactor: item.percentage / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getProgressColor(item.type),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Percentage label on the bar
                      if (item.percentage > 15) // Only show if there's enough space
                        Positioned(
                          left: 8.w,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Text(
                              '${item.percentage.toInt()}%',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomProgressIndicators(BuildContext context) {
    return Row(
      children: [
        // Empty space for label area
        Expanded(
          flex: 3,
          child: Container(),
        ),

        // Progress indicators area
        Expanded(
          flex: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressIndicator(context, '100%'),
              _buildProgressIndicator(context, '80%'),
              _buildProgressIndicator(context, '60%'),
              _buildProgressIndicator(context, '40%'),
              _buildProgressIndicator(context, '20%'),
              _buildProgressIndicator(context, '0%'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context, String percentage) {
    return Text(
      percentage,
      style: context.textTheme.labelSmall?.copyWith(
        color: context.color.outlineVariant,
        fontWeight: FontWeight.w400,
        fontSize: 10,
      ),
    );
  }

  Color _getProgressColor(ProjectProgressType type) {
    switch (type) {
      case ProjectProgressType.totalDelivery:
        return const Color(0xFF2E7D32); // Green
      case ProjectProgressType.financing:
        return const Color(0xFF1976D2); // Blue
      case ProjectProgressType.activities:
        return const Color(0xFFD32F2F); // Red
      case ProjectProgressType.outputs:
        return const Color(0xFFFF8F00); // Orange
    }
  }
}

// Model classes for the progress chart data
class ProjectProgressItemModel {
  final ProjectProgressType type;
  final String titleKey;
  final double percentage;

  ProjectProgressItemModel({
    required this.type,
    required this.titleKey,
    required this.percentage,
  });
}

enum ProjectProgressType {
  totalDelivery,
  financing,
  activities,
  outputs,
}
