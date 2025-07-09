import 'package:core_package/core/utility/export.dart';

class CandidateInfoCardWidget extends StatelessWidget {
  final bool? isPrimaryColor;
  final String title;
  final String value;

  const CandidateInfoCardWidget(
      {super.key,
      this.isPrimaryColor = true,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: (isPrimaryColor ?? true)
              ? Styles.PRIMARY_COLOR.withValues(alpha: 0.1)
              : context.color.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: context.textTheme.titleLarge
                    ?.copyWith(color: context.color.primary)),
            4.sh,
            Text(title,
                style: context.textTheme.titleSmall
                    ?.copyWith(fontSize: 10, color: context.color.outline)),
          ],
        ),
      ),
    );
  }
}
