import '../../shared/strategy_exports.dart';

class ObjectiveCardContent extends StatelessWidget {
  const ObjectiveCardContent({super.key, required this.objective});
  final ObjectiveDetailsModel objective;

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
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Styles.LIGHT_GREY_BORDER)),
              child: Images(
                image: "assets/svgs/moneys.svg",
                width: 24.w,
                height: 24.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    objective.title ?? "",
                    style: AppTextStyles.w700
                        .copyWith(fontSize: 16, color: Styles.HEADER),
                  ),
                  SizedBox(height: 4.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: allTranslations.text("time_left") +
                          " ${(objective.endDate?.difference(DateTime.now()).inDays ?? 0) > 0 ? (objective.endDate?.difference(DateTime.now()).inDays ?? 0) : 0}" +
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
                              (objective.endDate ?? DateTime.now())
                                  .format("d/M/yyyy"),
                          style: AppTextStyles.w400
                              .copyWith(fontSize: 14, color: Styles.DETAILS),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: (objective.weight ?? 0) / 100,
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
              "${objective.weight?.toStringAsFixed(1) ?? ""}%",
              style: AppTextStyles.w700
                  .copyWith(fontSize: 14, color: Styles.HEADER),
            ),
          ],
        ),
      ],
    );
  }
}
