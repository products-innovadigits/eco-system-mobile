import '../../shared/pms_exports.dart';

class ChallengeRiskCardWidget extends StatelessWidget {
  final bool? isPrimaryColor;
  final String title, value;

  const ChallengeRiskCardWidget(
      {super.key,
      this.isPrimaryColor = false,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: (isPrimaryColor ?? true)
              ? context.color.secondary.withValues(alpha: 0.1)
              : Color(0xffE6EDF5),
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: context.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            4.sh,
            Text(title,
                style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 10, color: context.color.outlineVariant)),
          ],
        ),
      ),
    );
  }
}
