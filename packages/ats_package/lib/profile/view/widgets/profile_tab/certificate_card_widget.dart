import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class CertificateCardWidget extends StatelessWidget {
  final CertificateModel certificate;

  const CertificateCardWidget({super.key, required this.certificate});

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  certificate.name ?? '-',
                  style: context.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
                4.sh,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (certificate.orginization != null &&
                        certificate.orginization!.isNotEmpty)
                      Text(
                        certificate.orginization ?? '-',
                        style: context.textTheme.bodySmall?.copyWith(
                            color: context.color.onSurfaceVariant,
                            fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    4.sw,
                    if (certificate.date != null &&
                        certificate.date!.isNotEmpty)
                      Text(
                      certificate.date ?? '-',
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
        // 8.sh,
        // ReadMoreText(
        //   'قمت بقيادة دورة حياة تطوير منتجات B2B و SaaS، مع ضمان التوافق مع الأهداف.قمت بقيادة دورة حياة تطوير قمت بقيادة دورة حياة تطوير منتجات B2B و SaaS، مع ضمان التوافق مع الأهداف.قمت بقيادة دورة حياة تطوير',
        //   trimMode: TrimMode.Line,
        //   trimLines: 2,
        //   colorClickableText: Styles.PRIMARY_COLOR,
        //   trimExpandedText: allTranslations.text(LocaleKeys.read_less),
        //   trimCollapsedText: allTranslations.text(LocaleKeys.read_more),
        //   moreStyle: AppTextStyles.w400
        //       .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 8),
        //   style: AppTextStyles.w400
        //       .copyWith(color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 8),
        // )
      ],
    );
  }
}
