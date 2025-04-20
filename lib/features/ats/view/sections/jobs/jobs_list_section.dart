import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/features/ats/bloc/jobs_bloc.dart';
import 'package:eco_system/features/ats/view/sections/candidate/candidate_stages_list_section.dart';
import 'package:eco_system/features/ats/view/widgets/jobs/job_details_widget.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobsListSection extends StatelessWidget {
  final bool? hasStatus;

  const JobsListSection({super.key, this.hasStatus = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobsBloc, AppState>(
      builder: (context, state) {
        final jobsBloc = context.read<JobsBloc>();
        return StreamBuilder<int?>(
            stream: jobsBloc.updateExpandedStream,
            builder: (context, snapshot) {
              return ListView.separated(
                  shrinkWrap: hasStatus ?? false ? false : true,
                  physics: hasStatus ?? false
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Container(
                        width: context.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        decoration: BoxDecoration(
                            color: Styles.WHITE_COLOR,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Styles.BORDER)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            JobDetailsWidget(hasStatus: hasStatus),
                            Row(
                              children: [
                                Images(image: 'assets/svgs/multi-user.svg'),
                                SizedBox(width: 8.w),
                                Text(
                                  '32 مرشح نشط في الأنابيب',
                                  style: AppTextStyles.w400.copyWith(
                                      color: Styles.PRIMARY_COLOR,
                                      fontSize: 12),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () =>
                                      jobsBloc.add(Expand(arguments: index)),
                                  child: Icon(
                                      snapshot.data != index
                                          ? Icons.keyboard_arrow_down_rounded
                                          : Icons.keyboard_arrow_up_rounded,
                                      color: snapshot.data != index
                                          ? Styles.ICON_GREY_COLOR
                                          : Styles.PRIMARY_COLOR),
                                )
                              ],
                            ),
                            if (snapshot.data == index) ...[
                              CandidateStagesListSection()
                            ]
                          ],
                        ),
                      ),
                  separatorBuilder: (context, index) => 16.sh,
                  itemCount: (hasStatus ?? false) ? 6 : 2);
            });
      },
    );
  }
}
