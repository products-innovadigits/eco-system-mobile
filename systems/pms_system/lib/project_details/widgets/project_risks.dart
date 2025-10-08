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
        return _RiskCardWidget(
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

class _RiskCardWidget extends StatelessWidget {
  final String title, value;
  final Color color;

  const _RiskCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            4.sh,
            Text(
              title,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
