import 'package:core_system/core/utility/export.dart';

class TryAgainWidget extends StatelessWidget {
  final VoidCallback onTryAgain;
  final Widget? header;

  const TryAgainWidget({super.key, required this.onTryAgain, this.header});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (header != null) ...[header!, 12.sh],
        Text(
          allTranslations.text(LocaleKeys.something_went_wrong),
          style: context.textTheme.labelSmall,
        ),
        12.sh,
        InkWell(
          onTap: onTryAgain,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                allTranslations.text(LocaleKeys.try_again),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.outlineVariant,
                  fontSize: 12,
                ),
              ),
              8.sw,
              Icon(
                Icons.refresh_outlined,
                color: context.color.outlineVariant,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
