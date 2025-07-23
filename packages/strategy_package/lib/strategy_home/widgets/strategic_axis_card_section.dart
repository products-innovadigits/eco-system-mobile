import 'package:core_package/core/utility/export.dart';
import 'package:core_package/core/widgets/custom_expansion_card.dart';
import 'package:strategy_package/strategy_home/bloc/strategy_bloc.dart';

class StrategicAxisCardSection extends StatelessWidget {
  const StrategicAxisCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StrategyBloc, AppState>(
      builder: (context, state) {
        final List<String> list = [
          'تقويم الانظمه الحكومية	',
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
            onTap: () => CustomNavigator.push(Routes.BSC),
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
              crossAxisSpacing: 8.w,
              childAspectRatio: 6
            ),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Icon(Icons.circle, color: context.color.secondary, size: 10),
                  8.sw,
                  Expanded(
                    child: Text(
                      list[index],
                      style: context.textTheme.labelSmall,
                    ),
                  ),
                ],
              );
            },
            itemCount: list.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
        );
      },
    );
  }
}
