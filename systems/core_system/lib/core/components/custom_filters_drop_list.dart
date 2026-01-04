import 'package:core_system/core/utility/export.dart';

class CustomFiltersDropList extends StatefulWidget {
  final List<DropListModel> options;
  final ValueChanged<DropListModel> onSelect;
  final DropListModel? initial;
  final String hintText;
  final String? labelText;
  final double? radius;

  const CustomFiltersDropList({
    super.key,
    required this.options,
    required this.onSelect,
    this.initial,
    required this.hintText,
    this.labelText,
    this.radius,
  });

  @override
  State<CustomFiltersDropList> createState() => _CustomFiltersDropListState();
}

class _CustomFiltersDropListState extends State<CustomFiltersDropList> {
  late DropListModel? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            allTranslations.text(widget.labelText ?? ''),
            style: context.textTheme.bodySmall,
          ),
          8.sh,
        ],
        Theme(
          data: Theme.of(context).copyWith(
            highlightColor: context.color.secondary.withValues(alpha: 0.2),
            popupMenuTheme: PopupMenuThemeData(
              position: PopupMenuPosition.under,
            ),
          ),
          child: PopupMenuButton<DropListModel>(
            initialValue: _current,
            onSelected: (DropListModel sel) {
              setState(() => _current = sel);
              widget.onSelect(sel);
            },
            itemBuilder: (_) => widget.options.map((o) {
              return PopupMenuItem<DropListModel>(
                value: o,
                child: Text(o.name ?? '', style: context.textTheme.labelSmall),
              );
            }).toList(),
            constraints: BoxConstraints(minWidth: context.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius ?? 8),
                color: context.color.surfaceContainer,
                border: Border.all(color: context.color.outline),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _current?.name ?? allTranslations.text(widget.hintText),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: _current != null
                          ? null
                          : context.color.outlineVariant,
                      fontWeight: _current != null
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  Images(
                    image: Assets.svgs.arrowDown.path,
                    width: 6,
                    height: 6,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
