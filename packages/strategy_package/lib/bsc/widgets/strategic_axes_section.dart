import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/bloc/bsc_bloc.dart';

class StrategicAxesSection extends StatelessWidget {
  const StrategicAxesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BscBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<BscBloc>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              allTranslations.text(LocaleKeys.strategic_results),
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 35.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: bloc.axes.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return _strategicAxisChip(
                    context,
                    title: bloc.axes[index],
                    isSelected: bloc.selectedAxes == index,
                    onTap: () => bloc.add(Select(arguments: index)),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
              expansionAnimationStyle: AnimationStyle(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
              title: Text(
                bloc.axes[bloc.selectedAxes],
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
                      bloc.results[bloc.selectedAxes],
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
      },
    );
  }
}

Widget _strategicAxisChip(
  BuildContext context, {
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: isSelected
            ? context.color.secondary
            : context.color.surfaceContainer,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: isSelected
              ? context.color.secondary
              : context.color.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Text(
          title,
          style: context.textTheme.labelSmall?.copyWith(
            color: isSelected ? context.color.onPrimary : context.color.primary,
          ),
        ),
      ),
    ),
  );
}
