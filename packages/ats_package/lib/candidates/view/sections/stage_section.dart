import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class StageSection extends StatelessWidget {
  final StageModel stage;

  const StageSection({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final Color stageColor = stage.color != null
        ? Color(int.parse('0xFF${stage.color!.substring(1)}'))
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
                style: context.textTheme.labelSmall
                    ?.copyWith(color: context.color.onSurfaceVariant),
              ),
              4.sw,
              Text('(${stage.count})',
                  style: context.textTheme.labelSmall
                      ?.copyWith(color: context.color.onSurfaceVariant)),
            ],
          ),
          16.sh,
          stage.count == 0
              ? Container(
                  width: context.w,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
                  decoration: BoxDecoration(
                      color: Styles.WHITE_COLOR,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.color.outlineVariant)),
                  child: Center(
                      child:
                          Text(allTranslations.text(LocaleKeys.no_candidates))),
                )
              : ListView.separated(
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
