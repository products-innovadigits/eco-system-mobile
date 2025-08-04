import 'package:pms_system/pms_home/widgets/request_card_widget.dart';

import '../../shared/pms_exports.dart';

class LatestRequestsSection extends StatelessWidget {
  const LatestRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.color.outline)),
      child: Column(
        children: [
          SectionTitle(
            title: allTranslations.text(LocaleKeys.latest_requests),
            withView: true,
            onViewTap: () {},
          ),
          Divider(color: context.color.outline),
          16.sh,
          Column(
            children: List.generate(4, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: RequestCardWidget(),
              );
            }),
          ),
          // 16.sh,
          // ProjectsProgressChart(projects: projects),

          // SizedBox(
          //   height: 104,
          //   child: HalfCircleAnalyticChart(projects),
          // ),
        ],
      ),
    );
  }
}
