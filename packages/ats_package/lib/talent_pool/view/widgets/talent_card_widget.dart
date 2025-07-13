import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';
import 'package:core_package/core/widgets/custom_check_box_widget.dart';

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
      highlightColor: context.color.secondary.withValues(alpha: 0.2),
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
            border: Border.all(color: context.color.outline)),
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
                    style: context.textTheme.labelSmall,
                  ),
                  2.sh,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          '${talent.jobTitle} . ',
                          style: context.textTheme.bodySmall?.copyWith(
                              fontSize: FontSizes.f10,
                              color: context.color.outlineVariant),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                          '${talent.chancesCount} ${allTranslations.text(LocaleKeys.chances)}',
                          style: context.textTheme.bodySmall?.copyWith(
                              fontSize: FontSizes.f10,
                              color: context.color.secondary))
                    ],
                  ),
                  if (talent.profile?.location != null &&
                      talent.profile?.experience != null &&
                      talent.profile?.expectedSalary != null &&
                      talent.profile?.noticePeriod != null)
                    _profileDetails(talent.profile, context),
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
                  child: Images(
                      image: Assets.svgs.arrowLeft.path,
                      color: context.color.outline)),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _profileDetails(ProfileModel? profile, BuildContext context) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.all(12.h),
        child: Divider(color: context.color.outline),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (profile?.location != null)
            Text(
              profile?.location ?? '',
              style: context.textTheme.titleSmall?.copyWith(
                  fontSize: FontSizes.f10, color: context.color.outline),
            ),
          if (profile?.location != null && profile?.experience != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Icon(Icons.circle,
                  color: context.color.outlineVariant, size: 5),
            ),
          if (profile?.experience != null)
            Text(
              '${allTranslations.text(LocaleKeys.experience)} ${profile?.experience ?? ''} ${allTranslations.text(LocaleKeys.years)}',
              style: context.textTheme.titleSmall?.copyWith(
                  fontSize: FontSizes.f10, color: context.color.outlineVariant),
            ),
          const Spacer(),
          Row(
            children: [
              if (profile?.expectedSalary != null)
                Text(
                    '${profile?.expectedSalary ?? ''} ${profile?.currency?.name ?? ''}',
                    style: context.textTheme.bodySmall?.copyWith(
                        fontSize: FontSizes.f10, color: context.color.primary)),
              if (profile?.expectedSalary != null &&
                  profile?.noticePeriod != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child:
                      Icon(Icons.circle, color: context.color.primary, size: 5),
                ),
              if (profile?.noticePeriod != null)
                Text('${profile?.noticePeriod ?? ''}',
                    style: context.textTheme.bodySmall?.copyWith(
                        fontSize: FontSizes.f10, color: context.color.primary)),
            ],
          )
        ],
      )
    ],
  );
}
