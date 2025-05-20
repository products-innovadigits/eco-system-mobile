import 'package:eco_system/components/custom_network_image.dart';
import 'package:eco_system/features/ats/talent_pool/model/candidate_model.dart';
import 'package:eco_system/utility/export.dart';

class TotalCandidatesSection extends StatelessWidget {
  final List<CandidateModel> talentsList;

  const TotalCandidatesSection({super.key, required this.talentsList});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              allTranslations.text(LocaleKeys.total_candidates),
              style: AppTextStyles.w400
                  .copyWith(fontSize: 12, color: Styles.DETAILS),
            ),
            4.sh,
            Text(
              talentsList.length.toString(),
              style: AppTextStyles.w700.copyWith(fontSize: 14),
            ),
          ],
        ),
        Stack(
          textDirection: TextDirection.ltr,
          children: List.generate(
              talentsList.length > 5 ? 5 : talentsList.length,
              (index) => Container(
                    width: 32.w,
                    height: 32.h,
                    margin: index == 0
                        ? EdgeInsets.only(left: 0)
                        : EdgeInsets.only(left: index * 17.w),
                    decoration: BoxDecoration(
                        color: Styles.PRIMARY_COLOR,
                        shape: BoxShape.circle,
                        border: Border.all(color: Styles.WHITE_COLOR)),
                    child: (index == 4 && talentsList.length > 5)
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.1),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                '+${talentsList.length - 5}',
                                style: AppTextStyles.w400.copyWith(
                                    color: Styles.WHITE_COLOR, fontSize: 11),
                              ),
                            ),
                          )
                        : CustomNetworkImage.circleNewWorkImage(backGroundColor: Styles.PRIMARY_COLOR ),
                  )),
        ),
      ],
    );
  }
}
