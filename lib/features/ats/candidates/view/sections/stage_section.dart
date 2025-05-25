import 'package:eco_system/features/ats/candidates/view/widgets/candidate_card_widget.dart';
import 'package:eco_system/features/ats/jobs/model/jobs_model.dart';
import 'package:eco_system/utility/export.dart';

class StageSection extends StatelessWidget {
  final StageModel stage;

  const StageSection({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final Color stageColor = stage.color != null
        ? Color(int.parse('0xFF' + stage.color!.substring(1)))
        : Styles.PRIMARY_COLOR;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: stageColor),
              SizedBox(width: 8.w),
              Text(
                stage.type ?? '',
                style: AppTextStyles.w500
                    .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR),
              ),
              4.sw,
              Text('(${stage.count})',
                  style: AppTextStyles.w500
                      .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 12)),
            ],
          ),
          16.sh,
        stage.count == 0 ? Container(
          width: context.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
          decoration: BoxDecoration(
              color: Styles.WHITE_COLOR,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Styles.BORDER)),
          child: Center(child: Text(allTranslations.text(LocaleKeys.no_candidates))),
        ) :  ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: stage.count ?? 0,
            itemBuilder: (context, index) {
              return CandidateCardWidget();
            },
            separatorBuilder: (context, index) => 16.sh,
          ),
        ],
      ),
    );
  }
}
