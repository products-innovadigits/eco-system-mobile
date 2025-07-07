import 'package:core_package/core/utility/export.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

abstract class CustomBottomSheet {
  static show(
      {Function()? onConfirm,
      String? label,
      String? buttonText,
      required Widget widget,
      double? height,
      Widget? child,
      bool? isLoading,
      bool withPadding = true,
      Function()? onCancel,
      Function()? onClose}) {
    return showMaterialModalBottomSheet(
      enableDrag: true,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      context: CustomNavigator.navigatorState.currentContext!,
      expand: false,
      useRootNavigator: true,
      isDismissible: true,
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(CustomNavigator.navigatorState.currentContext!)
              .viewInsets,
          child: Container(
            height: height ?? 500.h,
            width: CustomNavigator.navigatorState.currentContext!.w,
            decoration: BoxDecoration(
              color: Styles.WHITE_COLOR,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.w),
                topLeft: Radius.circular(30.w),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 60.w,
                  height: 4.h,
                  margin: EdgeInsets.only(
                    left: 18.w,
                    right: 18.w,
                    top: 8.h,
                    bottom: 18.h,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Styles.HINT,
                      borderRadius: BorderRadius.circular(100)),
                ),
                if (label != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          label,
                          style: AppTextStyles.w500.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            CustomNavigator.pop();
                            onCancel?.call();
                          },
                          child: const Icon(
                            Icons.clear,
                            size: 24,
                            color: Styles.DETAILS,
                          ),
                        )
                      ],
                    ),
                  ),
                if (label != null)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 18.w),
                    child: const Divider(
                      color: Styles.BORDER_COLOR,
                    ),
                  ),
                Expanded(child: widget),
                Visibility(
                  visible: child != null || onConfirm != null,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                    child: child ??
                        CustomBtn(
                          text: allTranslations.text(buttonText
                              ?? "confirm"),
                          loading: isLoading ?? false,
                          onPressed: onConfirm,
                        ),
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(
                            CustomNavigator.navigatorState.currentContext!)
                        .viewInsets
                        .bottom),
              ],
            ),
          ),
        );
      },
    ).then((value) => onClose?.call());
  }
}
