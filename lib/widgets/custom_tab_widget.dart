import 'package:eco_system/utility/export.dart';

class CustomTabWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomTabWidget(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.onTap});

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
            color: Styles.WHITE_COLOR,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Styles.PRIMARY_COLOR : Styles.BORDER,
                width: isSelected ? 2 : 1,
              ),
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            style: AppTextStyles.w400.copyWith(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? Styles.PRIMARY_COLOR
                  : Styles.SUB_TEXT_DARK_COLOR,
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
