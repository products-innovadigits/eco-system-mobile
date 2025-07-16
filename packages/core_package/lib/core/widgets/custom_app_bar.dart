import 'package:core_package/core/utility/export.dart';

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
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size(
    CustomNavigator.navigatorState.currentContext!.w,
    (withSearch ?? false) ? 122.h : 65.h,
  );
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 24.h),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          border: Border(
            bottom: BorderSide(
              color: widget.withBottomBorder
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
                if(widget.withBackBtn == true)...[
                  InkWell(
                    onTap: () {
                      widget.onBackBtn?.call();
                      CustomNavigator.pop();
                    },
                    child: RotatedBox(
                      quarterTurns: mainAppBloc.lang.valueOrNull == "en" ? 2 : 0,
                      child: Images(
                        image: Assets.svgs.arrowBack.path,
                        color: context.color.primary,
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                  ),
                  8.sw,
                ],
                Text(
                  widget.title ?? "",
                  style: context.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                widget.action ?? SizedBox(width: 16.w),
              ],
            ),
            if (widget.withSearch ?? false)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: TextField(
                        controller: widget.searchController,
                        focusNode: _focusNode,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          _focusNode.unfocus();
                        },
                        onChanged: (v) {
                          if (_debounceTimer?.isActive ?? false) {
                            _debounceTimer?.cancel();
                          }
                          _debounceTimer = Timer(
                            const Duration(milliseconds: 600),
                            () {
                              widget.onSearching!(v);
                            },
                          );
                        },
                        onTap: widget.onTapSearch,
                        readOnly: widget.onSearching == null,
                        decoration: InputDecoration(
                          suffixIcon: _isSearchFocused
                              ? GestureDetector(
                                  onTap: () {
                                    if (widget.onCanceling != null) {
                                      widget.onCanceling!();
                                      widget.searchController?.clear();
                                      _focusNode.unfocus();
                                    }
                                  },
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
                          hintText: widget.searchHintText,
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
                    width: _isSearchFocused ? 0 : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.withSorting ?? false) ...[
                          8.sw,
                          GestureDetector(
                            onTap: () {
                              if (widget.onSorting != null) {
                                widget.onSorting!();
                              }
                            },
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
                                  if (widget.isSorted == true)
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
                        if (widget.withFilter ?? false) ...[
                          8.sw,
                          GestureDetector(
                            onTap: () {
                              if (widget.onFiltering != null) {
                                widget.onFiltering!();
                              }
                            },
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
                                      image: Assets.svgs.filter.path,
                                      color: context.color.outlineVariant,
                                      height: 20.h,
                                      width: 20.w,
                                    ),
                                  ),
                                  if (widget.isFiltered == true)
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
