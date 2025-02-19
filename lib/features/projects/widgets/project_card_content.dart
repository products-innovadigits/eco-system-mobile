import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import '../../../helpers/styles.dart';
import '../../../helpers/text_styles.dart';
import '../../../widgets/images.dart';
import '../../project_details/model/project_details_model.dart';

class ProjectCardContent extends StatelessWidget {
  const ProjectCardContent({super.key, required this.project});
  final ProjectDetailsModel project;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                  color: Styles.WHITE_COLOR,
                  shape: BoxShape.circle,
                  border: Border.all(color: Styles.LIGHT_GREY_BORDER)),
              child: Images(
                image: "assets/svgs/moneys.svg",
                width: 24.w,
                height: 24.w,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title ?? "",
                      style: AppTextStyles.w700
                          .copyWith(fontSize: 16, color: Styles.HEADER),
                    ),
                    SizedBox(height: 4.h),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text: allTranslations.text("time_left") +
                            " ${(project.endDate?.difference(DateTime.now()).inDays ?? 0) > 0 ? (project.endDate?.difference(DateTime.now()).inDays ?? 0) : 0}" +
                            allTranslations.text("days"),
                        style: AppTextStyles.w400
                            .copyWith(fontSize: 12, color: Styles.DARK_RED),
                        children: [
                          TextSpan(
                            text: " | ",
                            style: AppTextStyles.w400
                                .copyWith(fontSize: 14, color: Styles.DETAILS),
                          ),
                          TextSpan(
                            text: allTranslations.text("deliver_date") +
                                ": " +
                                (project.endDate ?? DateTime.now())
                                    .format("d/M/yyyy"),
                            style: AppTextStyles.w400
                                .copyWith(fontSize: 14, color: Styles.DETAILS),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if(project.status != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color:
                    Styles.statusColors(project.status ?? "").withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                project.status ?? "",
                style: AppTextStyles.w500.copyWith(
                    fontSize: 12,
                    color: Styles.statusColors(project.status ?? "")),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: (project.weight ?? 0) / 100,
              color: Styles.PRIMARY_COLOR,
              backgroundColor: Styles.HINT,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                allTranslations.text("progress"),
                style: AppTextStyles.w400
                    .copyWith(fontSize: 14, color: Styles.DETAILS),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              "${project.weight ?? 0}%",
              style: AppTextStyles.w700
                  .copyWith(fontSize: 14, color: Styles.HEADER),
            ),
          ],
        ),
      ],
    );
  }
}
