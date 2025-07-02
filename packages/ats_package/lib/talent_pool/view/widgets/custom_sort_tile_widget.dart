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
        children: [
          Container(
            width: 22.w,
            height: 22.h,
            decoration: BoxDecoration(
                color:
                    isSelected ? Styles.PRIMARY_COLOR : Styles.ICON_GREY_COLOR,
                shape: BoxShape.circle),
            child: Center(
                child: const Icon(
              Icons.circle,
              color: Styles.WHITE_COLOR,
              size: 13,
            )),
          ),
          8.sw,
          Text(
            title,
            style: AppTextStyles.w500.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
