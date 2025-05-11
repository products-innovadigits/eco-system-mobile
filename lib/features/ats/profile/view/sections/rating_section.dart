import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class RatingSection extends StatefulWidget {
  final Function(int index)? onRatingSelected;
  const RatingSection({super.key, this.onRatingSelected});

  @override
  State<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  int selectedRatingIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        6,
        (index) => Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                widget.onRatingSelected?.call(index);
                selectedRatingIndex = index;
              });
            },
            child: Container(
                margin: EdgeInsetsDirectional.only(end: 8.w),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: selectedRatingIndex == index
                      ? Styles.PRIMARY_COLOR.withValues(alpha: 0.1)
                      : Colors.transparent,
                  border: Border.all(
                      color: selectedRatingIndex == index
                          ? Styles.PRIMARY_COLOR
                          : Styles.BORDER),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    index.toString(),
                    style: AppTextStyles.w400.copyWith(
                        color: selectedRatingIndex == index
                            ? Styles.PRIMARY_COLOR
                            : Styles.DETAILS),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
