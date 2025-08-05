import 'package:core_system/core/utility/export.dart';
import 'package:core_system/core/widgets/custom_expansion_card.dart';
import 'package:strategy_system/strategy_home/bloc/strategy_bloc.dart';

class StrategicAxisCardSection extends StatelessWidget {
  const StrategicAxisCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StrategyBloc, AppState>(
      builder: (context, state) {
        final List<String> list = [
          'تقويم الانظمه الحكومية',
          'تطوير الأنظمة الحكومية',
          'تطوير الأنظمة الحكومية',
          'تطوير الأنظمة الحكومية',
          'تطوير الأنظمة الحكومية',
          'تطوير الأنظمة الحكومية',
          'تطوير الأنظمة الحكومية',
        ];
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
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 6.w,
              childAspectRatio: 6,
            ),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Icon(Icons.circle, color: context.color.secondary, size: 10),
                  2.sw,
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: list[index],
                        style: context.textTheme.labelSmall,
                        children: [
                          TextSpan(
                            text: ' (5)',
                            style: context.textTheme.labelMedium?.copyWith(
                              color: context.color.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: list.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        );
      },
    );
  }
}
