import '../../shared/pms_exports.dart';

class ProjectChallenges extends StatelessWidget {
  const ProjectChallenges({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _ChallengeCardWidget(
          effect: allTranslations.text(LocaleKeys.low_effect),
          processedChallengeNumber: '5',
          challengeNumberToProcess: '20',
          color: colors.primary,
        ),
        _ChallengeCardWidget(
          effect: allTranslations.text(LocaleKeys.average_effect),
          processedChallengeNumber: '20',
          challengeNumberToProcess: '40',
          color: colors.secondary,
        ),
        _ChallengeCardWidget(
          effect: allTranslations.text(LocaleKeys.high_effect),
          processedChallengeNumber: '60',
          challengeNumberToProcess: '120',
          color: colors.errorContainer,
        ),
      ],
    );
  }
}

class _ChallengeCardWidget extends StatelessWidget {
  final String effect, processedChallengeNumber, challengeNumberToProcess;
  final Color color;

  const _ChallengeCardWidget({
    required this.effect,
    required this.processedChallengeNumber,
    required this.color,
    required this.challengeNumberToProcess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: effect,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: FontSizes.f10,
                color: color,
              ),
              children: [
                TextSpan(
                  text:
                      ' ($challengeNumberToProcess ${allTranslations.text(LocaleKeys.challenge)})',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${allTranslations.text(LocaleKeys.have_been_processing)} $processedChallengeNumber ${allTranslations.text(LocaleKeys.challenges)}',
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
