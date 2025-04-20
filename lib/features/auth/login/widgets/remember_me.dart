import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/styles.dart';
import '../../../../helpers/text_styles.dart';

class RememberMe extends StatelessWidget {
  const RememberMe({
    this.check = false,
    required this.onChange,
  });
  final bool check;
  final Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () => onChange(!check),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 18.w,
              height: 18.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: check ? Styles.PRIMARY_COLOR : Styles.WHITE_COLOR,
                  border: Border.all(
                      color: check ? Styles.PRIMARY_COLOR : Styles.DETAILS,
                      width: 1)),
              child: check
                  ? const Icon(
                      Icons.check,
                      color: Styles.WHITE_COLOR,
                      size: 14,
                    )
                  : null,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                allTranslations.text("remember_me"),
                maxLines: 1,
                style: AppTextStyles.w500.copyWith(
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                    color: check ? Styles.PRIMARY_COLOR : Styles.TITLE),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
