import 'package:core_package/core/utility/export.dart';

class CustomTabWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomTabWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? context.color.secondary.withValues(alpha: 0.1)
                : context.color.surfaceContainer,
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? context.color.secondary
                    : context.color.outline,
                width: isSelected ? 2 : 1,
              ),
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? context.color.secondary
                  : context.color.outlineVariant,
            ),
            child: Text(
              allTranslations.text(title),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
