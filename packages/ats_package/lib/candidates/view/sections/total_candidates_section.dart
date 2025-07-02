import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class TotalCandidatesSection extends StatelessWidget {
  final List<CandidateModel> talentsList;
  final int candidatesCount;

  const TotalCandidatesSection(
      {super.key, required this.talentsList, required this.candidatesCount});

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
              candidatesCount.toString(),
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
                                '+${candidatesCount - 5}',
                                style: AppTextStyles.w400.copyWith(
                                    color: Styles.WHITE_COLOR,
                                    fontSize: candidatesCount > 99 ? 10 : 11),
                              ),
                            ),
                          )
                        : CustomNetworkImage.circleNewWorkImage(
                            backGroundColor: Styles.PRIMARY_COLOR),
                  )),
        ),
      ],
    );
  }
}
