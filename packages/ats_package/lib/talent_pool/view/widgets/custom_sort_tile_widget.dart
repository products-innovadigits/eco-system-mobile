import 'package:core_package/core/utility/export.dart';

class CustomSortTileWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function()? onSelect;

  const CustomSortTileWidget(
      {super.key,
      required this.title,
      required this.isSelected,
      this.onSelect});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22.w,
            height: 22.h,
            decoration: BoxDecoration(
                color: isSelected
                    ? context.color.primary
                    : context.color.outline.withValues(alpha: 0.6),
                shape: BoxShape.circle),
            child: Center(
                child:  Icon(
              Icons.circle,
              color: context.color.surfaceContainer,
              size: 13,
            )),
          ),
          8.sw,
          Text(
            title,
            style: context.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
