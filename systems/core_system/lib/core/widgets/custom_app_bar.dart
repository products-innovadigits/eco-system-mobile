import 'package:core_system/core/components/custom_screen_type_layout_widget.dart';
import 'package:core_system/core/utility/export.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final String? searchHintText;
  final Widget? action;
  final TextEditingController? searchController;
  final bool withBottomBorder;
  final bool? withSearch;
  final bool? withFilter;
  final bool? isFiltered;
  final bool? isSorted;
  final bool? withSorting;
  final bool? withCancelBtn;
  final VoidCallback? onCanceling;
  final VoidCallback? onFiltering;
  final VoidCallback? onSorting;
  final ValueChanged? onSearching;
  final VoidCallback? onTapSearch;
  final VoidCallback? onBackBtn;
  final bool? withBackBtn;
  final TextAlign textAlign;

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
    this.onBackBtn,
    this.searchController,
    this.isFiltered = false,
    this.isSorted = false,
    this.withBackBtn = true,
    this.textAlign = TextAlign.start,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize {
    final ctx = CustomNavigator.navigatorState.currentContext!;
    final isLandscape = MediaQuery.of(ctx).orientation == Orientation.landscape;
    final height = (withSearch ?? false)
        ? (isLandscape ? 90.0 : 122.h)
        : (isLandscape ? 44.0 : 60.h);
    return Size(double.infinity, height);
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  late FocusNode _focusNode;
  bool _isSearchFocused = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isSearchFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String v) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }
    _debounceTimer = Timer(
      const Duration(milliseconds: 600),
      () => widget.onSearching!(v),
    );
  }

  void _onClearSearch() {
    bool hasText = widget.searchController?.text.isNotEmpty == true;
    widget.searchController?.clear();
    _focusNode.unfocus();
    if (hasText && widget.onCanceling != null) {
      widget.onCanceling!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreenTypeLayoutWidget(
      mobilePortrait: (ctx) => CustomAppBarPortrait(
        appBar: widget,
        focusNode: _focusNode,
        isSearchFocused: _isSearchFocused,
        onSearchChanged: _onSearchChanged,
        onClearSearch: _onClearSearch,
      ),
      mobileLandscape: (ctx) => CustomAppBarLandscape(
        appBar: widget,
        focusNode: _focusNode,
        isSearchFocused: _isSearchFocused,
        onSearchChanged: _onSearchChanged,
        onClearSearch: _onClearSearch,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Portrait – uses .w / .h (screenutil) sizing
// ---------------------------------------------------------------------------

class CustomAppBarPortrait extends StatelessWidget {
  final CustomAppBar appBar;
  final FocusNode focusNode;
  final bool isSearchFocused;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const CustomAppBarPortrait({
    super.key,
    required this.appBar,
    required this.focusNode,
    required this.isSearchFocused,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.h),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          border: Border(
            bottom: BorderSide(
              color: appBar.withBottomBorder
                  ? context.color.outline
                  : Colors.transparent,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (appBar.withBackBtn == true) ...[
                  InkWell(
                    onTap: () {
                      appBar.onBackBtn?.call();
                      CustomNavigator.pop();
                    },
                    child: RotatedBox(
                      quarterTurns: mainAppBloc.lang.valueOrNull == "en"
                          ? 2
                          : 0,
                      child: Images(
                        image: Assets.svgs.arrowBack.path,
                        color: context.color.primary,
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: Text(
                    appBar.title ?? "",
                    maxLines: 2,
                    style: context.textTheme.titleLarge,
                    textAlign: appBar.textAlign,
                  ),
                ),
                SizedBox(width: 8),
                appBar.action ?? SizedBox(width: 16.w),
              ],
            ),
            if (appBar.withSearch ?? false)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: TextField(
                        controller: appBar.searchController,
                        focusNode: focusNode,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => focusNode.unfocus(),
                        onChanged: onSearchChanged,
                        onTap: appBar.onTapSearch,
                        readOnly: appBar.onSearching == null,
                        decoration: InputDecoration(
                          suffixIcon: isSearchFocused
                              ? GestureDetector(
                                  onTap: onClearSearch,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Images(
                                      image: Assets.svgs.closeCircle.path,
                                      color: context.color.outlineVariant,
                                    ),
                                  ),
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: context.color.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: context.color.outline,
                            ),
                          ),
                          hintText: appBar.searchHintText,
                          hintStyle: context.textTheme.bodySmall?.copyWith(
                            color: context.color.outlineVariant,
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(14),
                            child: Images(image: Assets.svgs.search.path),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                        ),
                        style: context.textTheme.titleSmall,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: isSearchFocused ? 0 : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (appBar.withSorting ?? false) ...[
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: appBar.onSorting,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: context.color.outline,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    child: Images(
                                      image: Assets.svgs.sort.path,
                                      color: context.color.outlineVariant,
                                      height: 20.h,
                                      width: 20.w,
                                    ),
                                  ),
                                  if (appBar.isSorted == true)
                                    PositionedDirectional(
                                      top: 2.h,
                                      start: 1.w,
                                      child: Icon(
                                        Icons.circle,
                                        color: context.color.secondary,
                                        size: 8,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (appBar.withFilter ?? false) ...[
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: appBar.onFiltering,
                            child: Container(
                              padding: EdgeInsets.all(10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: context.color.outline,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    child: Images(
                                      image: Assets.svgs.filter.path,
                                      color: context.color.outlineVariant,
                                      height: 20.h,
                                      width: 20.w,
                                    ),
                                  ),
                                  if (appBar.isFiltered == true)
                                    PositionedDirectional(
                                      top: 0,
                                      start: 2.w,
                                      child: Icon(
                                        Icons.circle,
                                        color: context.color.secondary,
                                        size: 8,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Landscape – fully fixed sizing, compact layout
// ---------------------------------------------------------------------------

class CustomAppBarLandscape extends StatelessWidget {
  final CustomAppBar appBar;
  final FocusNode focusNode;
  final bool isSearchFocused;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const CustomAppBarLandscape({
    super.key,
    required this.appBar,
    required this.focusNode,
    required this.isSearchFocused,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          border: Border(
            bottom: BorderSide(
              color: appBar.withBottomBorder
                  ? context.color.outline
                  : Colors.transparent,
            ),
          ),
        ),
        child: (appBar.withSearch ?? false)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (appBar.withBackBtn == true) ...[
                    InkWell(
                      onTap: () {
                        appBar.onBackBtn?.call();
                        CustomNavigator.pop();
                      },
                      child: RotatedBox(
                        quarterTurns: mainAppBloc.lang.valueOrNull == "en"
                            ? 2
                            : 0,
                        child: Images(
                          image: Assets.svgs.arrowBack.path,
                          color: context.color.primary,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                  Flexible(
                    flex: 0,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 160),
                      child: Text(
                        appBar.title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleMedium,
                        textAlign: appBar.textAlign,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: appBar.searchController,
                        focusNode: focusNode,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => focusNode.unfocus(),
                        onChanged: onSearchChanged,
                        onTap: appBar.onTapSearch,
                        readOnly: appBar.onSearching == null,
                        decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: isSearchFocused
                              ? GestureDetector(
                                  onTap: onClearSearch,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Images(
                                      image: Assets.svgs.closeCircle.path,
                                      color: context.color.outlineVariant,
                                    ),
                                  ),
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: context.color.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: context.color.outline,
                            ),
                          ),
                          hintText: appBar.searchHintText,
                          hintStyle: context.textTheme.bodySmall?.copyWith(
                            color: context.color.outlineVariant,
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10),
                            child: Images(image: Assets.svgs.search.path),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                        ),
                        style: context.textTheme.titleSmall,
                      ),
                    ),
                  ),
                  if (appBar.withSorting ?? false) ...[
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: appBar.onSorting,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: context.color.outline),
                        ),
                        child: Stack(
                          children: [
                            Images(
                              image: Assets.svgs.sort.path,
                              color: context.color.outlineVariant,
                              height: 20,
                              width: 20,
                            ),
                            if (appBar.isSorted == true)
                              PositionedDirectional(
                                top: 0,
                                start: 0,
                                child: Icon(
                                  Icons.circle,
                                  color: context.color.secondary,
                                  size: 7,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (appBar.withFilter ?? false) ...[
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: appBar.onFiltering,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: context.color.outline),
                        ),
                        child: Stack(
                          children: [
                            Images(
                              image: Assets.svgs.filter.path,
                              color: context.color.outlineVariant,
                              height: 20,
                              width: 20,
                            ),
                            if (appBar.isFiltered == true)
                              PositionedDirectional(
                                top: 0,
                                start: 0,
                                child: Icon(
                                  Icons.circle,
                                  color: context.color.secondary,
                                  size: 7,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (appBar.action != null) ...[
                    SizedBox(width: 8),
                    appBar.action!,
                  ],
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (appBar.withBackBtn == true) ...[
                    InkWell(
                      onTap: () {
                        appBar.onBackBtn?.call();
                        CustomNavigator.pop();
                      },
                      child: RotatedBox(
                        quarterTurns: mainAppBloc.lang.valueOrNull == "en"
                            ? 2
                            : 0,
                        child: Images(
                          image: Assets.svgs.arrowBack.path,
                          color: context.color.primary,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      appBar.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleLarge,
                      textAlign: appBar.textAlign,
                    ),
                  ),
                  SizedBox(width: 8),
                  appBar.action ?? SizedBox(width: 16),
                ],
              ),
      ),
    );
  }
}
