import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class EducationCardWidget extends StatelessWidget {
  final EducationModel educationModel;

  const EducationCardWidget({super.key, required this.educationModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Styles.PRIMARY_COLOR.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Images(
                  image: Assets.svgs.building.path,
                  color: context.color.onSurface),
            ),
            8.sw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  educationModel.school ?? 'اينوفا ديجتس',
                  style: context.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
                4.sh,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      educationModel.degree ?? 'قائد تصميم المنتجات .',
                      style: context.textTheme.bodySmall?.copyWith(
                          color: context.color.onSurfaceVariant,
                          fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.sw,
                    Text(
                      '${educationModel.startDate} - ${educationModel.endDate}',
                      style: context.textTheme.bodySmall?.copyWith(
                          color: context.color.outline, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        if (educationModel.fieldStudy != null &&
            educationModel.fieldStudy!.isNotEmpty) ...[
          8.sh,
          // Using DefaultTextStyle to apply a consistent style cause it's not working with ReadMoreText directly
          DefaultTextStyle.merge(
            style: context.textTheme.labelSmall
                ?.copyWith(color: context.color.outline, fontSize: 10),
            child: ReadMoreText(
              educationModel.fieldStudy ?? '',
              trimMode: TrimMode.Line,
              colorClickableText: context.color.onSurfaceVariant,
              trimExpandedText: allTranslations.text(LocaleKeys.read_less),
              trimCollapsedText: allTranslations.text(LocaleKeys.read_more),
              lessStyle: context.textTheme.labelSmall
                  ?.copyWith(color: context.color.onSurfaceVariant , fontSize: 10),
              moreStyle: context.textTheme.labelSmall
                  ?.copyWith(color: context.color.onSurfaceVariant , fontSize: 10),
            ),
          )
        ],
      ],
    );
  }
}
