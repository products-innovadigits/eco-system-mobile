import 'package:core_system/core/widgets/custom_expansion_card.dart';
import 'package:strategy_system/strategic_axes/strategic_axes_objectives_resolver.dart';

import '../../shared/strategy_exports.dart';

Color _strategicAxisDotColor(BuildContext context, String? colorCode) {
  final raw = (colorCode != null && colorCode.isNotEmpty)
      ? colorCode
      : '#175CD3';
  try {
    return Color(int.parse(raw.replaceFirst('#', '0xff')));
  } catch (_) {
    return context.color.secondary;
  }
}

VisionDataModel? _visionFromBscState(AppState state) {
  if (state is Done) {
    final data = state.data;
    if (data is VisionDataModel) return data;
  }
  return null;
}

class StrategicAxisCardSection extends StatelessWidget {
  const StrategicAxisCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    // [BscBloc] is provided app-wide from [StrategyModule]; same [VisionDataModel]
    // as [StrategicAxesView] / [StrategicAxesSection].
    return BlocBuilder<BscBloc, AppState>(
      builder: (context, state) {
        final vision = _visionFromBscState(state);
        final axes = effectiveStrategicAxesList(vision);

        return CustomExpansionCard(
          title: allTranslations.text(LocaleKeys.strategic_axis),
          action: InkWell(
            onTap: () =>
                CustomNavigator.push(Routes.STRATEGIC_AXES, arguments: true),
            child: Text(
              allTranslations.text(LocaleKeys.view_more),
              style: context.textTheme.labelSmall?.copyWith(
                color: context.color.secondary,
              ),
            ),
          ),
          withExpanded: false,
          withMargin: false,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 8.w,
              // Fixed row height so titles are not clipped; aspect ratio 6 was far too shallow.
              mainAxisExtent: 30.h,
            ),
            itemBuilder: (context, index) {
              final axis = axes[index];
              final count = strategicAxisObjectiveCount(vision, index);
              final dotColor = _strategicAxisDotColor(context, axis.colorCode);
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 3.h),
                      child: Icon(Icons.circle, color: dotColor, size: 8.sp),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: context.textTheme.bodySmall?.copyWith(
                            height: 1.25,
                          ),
                          text: axis.title ?? '',
                          children: [
                            TextSpan(
                              text: ' ($count)',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.color.secondary,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: axes.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        );
      },
    );
  }
}
