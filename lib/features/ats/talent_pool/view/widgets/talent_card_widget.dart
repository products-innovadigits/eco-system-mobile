import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/utility/export.dart';

class TalentCardWidget extends StatelessWidget {
  final bool? isSelectionActive;
  final VoidCallback onSelectTalent;
  final bool? isTalentSelected;
  final CandidateModel talent;

  const TalentCardWidget(
      {super.key,
      this.isSelectionActive,
      required this.onSelectTalent,
      this.isTalentSelected,
      required this.talent});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Styles.PRIMARY_COLOR.withValues(alpha: 0.1),
      onLongPress: () {
        if (!isSelectionActive!) {
          context.read<TalentPoolBloc>().add(Select(arguments: true));
          onSelectTalent();
        }
      },
      onTap: () {
        if (isSelectionActive == true) {
          onSelectTalent();
        } else {
          CustomNavigator.push(Routes.PROFILE,
              arguments:
                  ProfileViewArgs(isTalent: true, candidateId: talent.id ?? 0));
        }
      },
      child: Container(
        width: context.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Styles.BORDER)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSelectionActive != null && isSelectionActive == true) ...[
              CustomCheckBoxWidget(
                  onCheck: onSelectTalent, isChecked: isTalentSelected == true),
              8.sw,
            ],
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Styles.PRIMARY_COLOR,
                  image: DecorationImage(
                      image: AssetImage(Assets.images.avatar.path))),
            ),
            8.sw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    talent.name ?? '',
                    style: AppTextStyles.w500
                        .copyWith(color: Styles.TEXT_COLOR, fontSize: 12),
                  ),
                  2.sh,
                  Row(
                    children: [
                      Text(
                        '${talent.jobTitle} . ',
                        style: AppTextStyles.w400.copyWith(
                            color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
                      ),
                      Text(
                          '${talent.chancesCount} ${allTranslations.text(LocaleKeys.chances)}',
                          style: AppTextStyles.w400.copyWith(
                              color: Styles.PRIMARY_COLOR, fontSize: 10))
                    ],
                  ),
                  if (talent.profile?.location != null &&
                      talent.profile?.experience != null &&
                      talent.profile?.expectedSalary != null &&
                      talent.profile?.noticePeriod != null)
                    _profileDetails(talent.profile),
                ],
              ),
            ),
            InkWell(
              onTap: () => CustomNavigator.push(Routes.PROFILE,
                  arguments: ProfileViewArgs(
                      isTalent: true, candidateId: talent.id ?? 0)),
              child: Container(
                  width: 24.w,
                  height: 24.h,
                  alignment: AlignmentDirectional.centerEnd,
                  padding: EdgeInsets.all(6),
                  child: Images(image: Assets.svgs.arrowLeft.path)),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _profileDetails(ProfileModel? profile) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.all(12.h),
        child: Divider(color: Styles.BORDER),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (profile?.location != null)
            Text(
              '${profile?.location ?? ''}',
              style: AppTextStyles.w500
                  .copyWith(color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
            ),
          if (profile?.location != null && profile?.experience != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Icon(Icons.circle,
                  color: Styles.SUB_TEXT_DARK_COLOR, size: 5),
            ),
          if (profile?.experience != null)
            Text(
              '${allTranslations.text(LocaleKeys.experience)} ${profile?.experience ?? ''} ${allTranslations.text(LocaleKeys.years)}',
              style: AppTextStyles.w500
                  .copyWith(color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
            ),
          const Spacer(),
          Row(
            children: [
              if (profile?.expectedSalary != null)
                Text(
                    '${profile?.expectedSalary ?? ''} ${profile?.currency?.name ?? ''}',
                    style: AppTextStyles.w400
                        .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 10)),
              if (profile?.expectedSalary != null &&
                  profile?.noticePeriod != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child:
                      Icon(Icons.circle, color: Styles.PRIMARY_COLOR, size: 5),
                ),
              if (profile?.noticePeriod != null)
                Text('${profile?.noticePeriod ?? ''}',
                    style: AppTextStyles.w400
                        .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 10)),
            ],
          )
        ],
      )
    ],
  );
}
