import 'package:eco_system/bloc/main_app_bloc.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? searchHintText;
  final Widget? action;
  final TextEditingController? searchController;
  final bool withBottomBorder;
  final bool? withSearch;
  final bool? withFilter;
  final bool? withSorting;
  final bool? withCancelBtn;
  final VoidCallback? onCanceling;
  final VoidCallback? onFiltering;
  final VoidCallback? onSorting;
  final ValueChanged? onSearching;
  final VoidCallback? onTapSearch;

  const CustomAppBar({
    super.key,
    required this.title,
    this.action,
    this.withBottomBorder = true,
    this.withSearch,
    this.onSearching,
    this.searchHintText,
    this.withFilter,
    this.onFiltering,
    this.onSorting,
    this.withSorting,
    this.onTapSearch,
    this.withCancelBtn,
    this.onCanceling,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
          color: Styles.WHITE_COLOR,
          border: Border(
              bottom: BorderSide(
                  color:
                      withBottomBorder ? Styles.BORDER : Colors.transparent))),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () => CustomNavigator.pop(),
                    child: RotatedBox(
                      quarterTurns:
                          mainAppBloc.lang.valueOrNull == "en" ? 2 : 0,
                      child: Images(
                        image: Assets.svgs.arrowBack.path,
                        color: Styles.DETAILS,
                        width: 20.w,
                        height: 20.h,
                      ),
                    )),
                8.sw,
                Expanded(
                  child: Text(
                    title ?? "",
                    style: AppTextStyles.w700.copyWith(
                      fontSize: 18,
                      color: Styles.TEXT_COLOR,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                action ?? SizedBox()
              ],
            ),
            if (withSearch ?? false)
              Row(
                crossAxisAlignment: (withCancelBtn ?? false)
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: TextField(
                        controller: searchController,
                        onChanged: (v) {
                          onSearching!(v);
                        },
                        onTap: () {
                          onTapSearch!();
                        },
                        readOnly: onSearching == null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Styles.BORDER),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Styles.BORDER),
                          ),
                          hintText: searchHintText,
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 12,
                              color: Styles.SUB_TEXT_DARK_COLOR),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(14),
                            child: Images(image: Assets.svgs.search.path),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                        ),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Styles.TEXT_COLOR),
                      ),
                    ),
                  ),
                  if (withSorting ?? false) ...[
                    8.sw,
                    GestureDetector(
                      onTap: () {
                        if (onSorting != null) {
                          onSorting!();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Styles.BORDER),
                        ),
                        child: Images(
                            image: Assets.svgs.sort.path,
                            height: 20.h,
                            width: 20.w),
                      ),
                    )
                  ],
                  if (withFilter ?? false) ...[
                    8.sw,
                    GestureDetector(
                      onTap: () {
                        if (onFiltering != null) {
                          onFiltering!();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Styles.BORDER),
                        ),
                        child: Images(
                            image: Assets.svgs.filter.path,
                            height: 20.h,
                            width: 20.w),
                      ),
                    )
                  ],
                  if (withCancelBtn ?? false) ...[
                    8.sw,
                    GestureDetector(
                        onTap: () {
                          if (onCanceling != null) {
                            onCanceling!();
                          }
                        },
                        child: Text(
                          LocaleKeys.cancel,
                          style: AppTextStyles.w400
                              .copyWith(color: Styles.SUB_TEXT_DARK_COLOR),
                        ))
                  ],
                ],
              )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(
      CustomNavigator.navigatorState.currentContext!.w,
      (withSearch ?? true) ? 120.h : 100.h);
}
