import 'package:pms_system/project_details/widgets/risk_challenge_card_widget.dart';

import '../../shared/pms_exports.dart';

class ProjectRisks extends StatelessWidget {
  final List<MobileRiskModel> risksList;

  const ProjectRisks({super.key, required this.risksList});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 2.5,
      ),
      children: List.generate(risksList.length, (index) {
        final risk = risksList[index];
        return RiskChallengeCardWidget(
          title: risk.label ?? '',
          value: risk.value.toString(),
          color: Color(
            int.parse((risk.background ?? '#000000').replaceFirst('#', '0xff')),
          ),
        );
      }),
      // [
      //   _RiskCardWidget(
      //       title: 'مؤكدة الحدوث',
      //       value: '20',
      //       color: colors.error),
      //   _RiskCardWidget(
      //     title: 'قابلة الحدوث',
      //     value: '30',
      //     color: colors.errorContainer,
      //   ),
      //   _RiskCardWidget(
      //       title: 'نادرة الحدوث',
      //       value: '50',
      //       color: colors.secondary),
      //   _RiskCardWidget(
      //     title: 'غير محتملة',
      //     value: '30',
      //     color: colors.tertiary,
      //   ),
      // ],
    );
  }
}
