import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/bsc/model/bsc_model.dart';
import 'package:strategy_system/bsc/widgets/bsc_info_container.dart';
import 'package:strategy_system/bsc/widgets/messages_list_section.dart';

class VisionSection extends StatelessWidget {
  final String visionTitle;
  final List<ValueModel> values;
  final List<MissionModel> messages;
  const VisionSection({super.key, required this.visionTitle, required this.values, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BscInfoContainer(
          color: LightColor.chartPrimary,
          title: allTranslations.text(LocaleKeys.vision),
          icon: Assets.svgs.vision.path,
          description: visionTitle,
        ),
        12.sh,
        BscInfoContainer(
          color: LightColor.chartTertiary,
          title: allTranslations.text(LocaleKeys.the_message),
          icon: Assets.svgs.multiMessage.path,
          descriptionWidget: MessagesListSection(messages: messages),
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
                      values[index].name ?? '',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: FontSizes.f10,
                        color: Color(0xff4E1D00),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, _) => 8.sw,
              itemCount: values.length,
            ),
          ),
        ),
      ],
    );
  }
}
