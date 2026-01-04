import 'package:core_system/core/utility/export.dart';

class NumbersRatingSection extends StatelessWidget {
  final int selectedRating;
  final Function(int rate)? onRatingSelected;

  const NumbersRatingSection({
    super.key,
    required this.selectedRating,
    this.onRatingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        6,
        (index) => Expanded(
          child: GestureDetector(
            onTap: () {
              onRatingSelected?.call(index);
            },
            child: Container(
              margin: EdgeInsetsDirectional.only(end: 8.w),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selectedRating == index
                    ? context.color.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedRating == index
                      ? context.color.primary
                      : context.color.outline,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  index.toString(),
                  style: AppTextStyles.w400.copyWith(
                    color: selectedRating == index
                        ? context.color.primary
                        : Styles.details,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
