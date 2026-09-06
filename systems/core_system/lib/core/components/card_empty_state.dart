import 'package:core_system/core/utility/export.dart';

/// Empty state for a home card body.
///
/// Sized to the same height the card has while loading and once it holds
/// data, so a card with no data keeps the dimensions of a normal card and
/// still shows its feature name in the header.
class CardEmptyState extends StatelessWidget {
  final double? height;
  final String? text;

  const CardEmptyState({super.key, this.height, this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? context.h * 0.2,
      width: context.w,
      child: Center(
        child: Text(
          text ?? allTranslations.text(LocaleKeys.there_is_no_data),
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.color.outlineVariant,
          ),
        ),
      ),
    );
  }
}
