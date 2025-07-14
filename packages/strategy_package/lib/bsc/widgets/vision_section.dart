import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/bloc/bsc_bloc.dart';
import 'package:strategy_package/bsc/widgets/bsc_info_container.dart';

class VisionSection extends StatelessWidget {
  const VisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BscBloc>();
    return Column(
      children: [
        BscInfoContainer(
          color: LightColor.chartPrimary,
          title: allTranslations.text(LocaleKeys.vision),
          icon: Assets.svgs.vision.path,
          description:
              'بناء مجتمع عصري من خلال توفير خدمات معلومات فائقة السرعة وسهولة الوصول إليها',
        ),
        12.sh,
        BscInfoContainer(
          color: LightColor.chartTertiary,
          title: allTranslations.text(LocaleKeys.the_message),
          icon: Assets.svgs.multiMessage.path,
          description:
              'بناء مجتمع عصري من خلال توفير خدمات معلومات فائقة السرعة وسهولة الوصول إليها',
        ),
        12.sh,
        BscInfoContainer(
          color: LightColor.chartSecondary,
          title: allTranslations.text(LocaleKeys.values),
          icon: Assets.svgs.valuesIcon.path,
          descriptionWidget: SizedBox(
            height: 25.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: context.color.surfaceContainer,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      bloc.values[index],
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: FontSizes.f10,
                        color: Color(0xff4E1D00),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, _) => 8.sw,
              itemCount: bloc.values.length,
            ),
          ),
        ),
      ],
    );
  }
}
