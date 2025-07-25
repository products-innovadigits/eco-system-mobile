import 'package:core_package/core/utility/export.dart';

class RememberMe extends StatelessWidget {
  const RememberMe({super.key,
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
                  color: check ? Styles.PRIMARY_COLOR : context.color.surfaceContainer,
                  border: Border.all(
                      color: check ? Styles.PRIMARY_COLOR : Styles.DETAILS,
                      width: 1)),
              child: check
                  ?  Icon(
                      Icons.check,
                      color: context.color.surfaceContainer,
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
