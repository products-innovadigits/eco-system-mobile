
import 'package:eco_system/utility/export.dart';

class WorkExperienceSection extends StatelessWidget {
  const WorkExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        return Container(
          width: context.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
              color: Styles.WHITE_COLOR,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Styles.BORDER)),
          child: Column(
            children: [
              InkWell(
                onTap: () => profileBloc.add(Expand(arguments: 0)),
                child: Row(
                  children: [
                    Text(allTranslations.text(LocaleKeys.work_experience),
                        style: AppTextStyles.w500),
                    4.sw,
                    Text('(اكثر من ٣ سنوات)',
                        style: AppTextStyles.w500
                            .copyWith(color: Styles.PRIMARY_COLOR)),
                    const Spacer(),
                    Icon(
                        profileBloc.isWorkExperienceExpanded == false
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_up_rounded,
                        color: profileBloc.isWorkExperienceExpanded == false
                            ? Styles.ICON_GREY_COLOR
                            : Styles.PRIMARY_COLOR),
                  ],
                ),
              ),
              if (profileBloc.isWorkExperienceExpanded == true) ...[
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        ExperienceEducationCardWidget(),
                    separatorBuilder: (context, index) => 24.sh,
                    itemCount: 3),
              ]
            ],
          ),
        );
      },
    );
  }
}
