import '../../shared/pms_exports.dart';

class ChallengeRiskCardWidget extends StatelessWidget {
  final String title, value;
  final Color color;

  const ChallengeRiskCardWidget(
      {super.key,
      required this.title,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: context.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600, color: color)),
            4.sh,
            Text(title,
                style: context.textTheme.bodySmall
                    ?.copyWith(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}
