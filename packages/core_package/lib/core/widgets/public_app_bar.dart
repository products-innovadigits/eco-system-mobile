import 'package:core_package/core/utility/export.dart';

import '../components/custom_arrow_back.dart';

class PublicAppbar extends StatefulWidget {
  final String? title;
  final bool hasFilter;
  final double? fontSize;
  final ValueChanged? onChange;
  final Function? onCancel;
  final bool? withBack;
  final Widget? filterWidget;

  const PublicAppbar({
    super.key,
    required this.title,
    this.onChange,
    this.fontSize,
    this.onCancel,
    this.hasFilter = false,
    this.withBack,
    this.filterWidget,
  }) : assert(
          hasFilter == false || filterWidget != null,
          'filterWidget cannot be null when hasFilter is true',
        );

  @override
  State<PublicAppbar> createState() => _PublicAppbarState();
}

class _PublicAppbarState extends State<PublicAppbar> {
  bool showSearch = false;

  bool _checkLang() => allTranslations.currentLanguage == "en";

  double _checkValue(bool value) => value ? MediaQueryHelper.width - 80 : 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQueryHelper.topPadding + 70,
      color: Styles.PRIMARY_COLOR,
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQueryHelper.topPadding, right: 24, left: 24),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showSearch
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: _checkLang() ? 24 : 0,
                              right: _checkLang() ? 0 : 24),
                          child: Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    onChanged: (v) {
                                      widget.onChange!(v);
                                    },
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: allTranslations.text("search"),
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                          color: Styles.WHITE_COLOR),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                      ),
                                    ),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Styles.WHITE_COLOR),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() => showSearch = false);
                                    widget.onCancel?.call();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      allTranslations.text("cancel"),
                                      style: const TextStyle(
                                        color: Styles.ACCENT_PRIMARY_COLOR,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Visibility(
                              visible: widget.withBack ?? false,
                              child: InkWell(
                                  onTap: () => CustomNavigator.pop(),
                                  child: const ArrowBack())),
                          const SizedBox(
                            width: 8,
                          ),
                          AnimatedWidgets(
                            horizontalOffset: 0.0,
                            verticalOffset: 0.0,
                            child: Center(
                              child: Text(
                                widget.title!,
                                style: TextStyle(
                                    fontSize: widget.fontSize ?? 24,
                                    fontWeight: FontWeight.w700,
                                    color: Styles.WHITE_COLOR),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
            widget.onChange != null
                ? AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    left: _checkLang()
                        ? _checkValue(!showSearch)
                        : _checkValue(showSearch),
                    right: _checkLang()
                        ? _checkValue(showSearch)
                        : _checkValue(!showSearch),
                    child: InkWell(
                      onTap: () {
                        setState(() => showSearch = true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: customImageIconSVG(imageName: 'search'),
                      ),
                    ),
                  )
                : Container(),
            if (widget.hasFilter)
              Positioned(
                left: _checkLang() ? MediaQueryHelper.width - 140 : null,
                right: _checkLang() ? null : MediaQueryHelper.width - 140,
                child: AnimatedOpacity(
                  opacity: showSearch ? 0 : 1,
                  duration: const Duration(milliseconds: 800),
                  child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => widget.filterWidget!,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)));
                      },
                      child: customImageIconSVG(imageName: "filter")),
                ),
              )
          ],
        ),
      ),
    );
  }
}
