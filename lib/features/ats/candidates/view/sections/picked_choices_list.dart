import 'package:eco_system/utility/export.dart';

class PickedChoicesList extends StatelessWidget {
  final List<DropListModel> list;
  final void Function(DropListModel item) onRemove;
  const PickedChoicesList({super.key, required this.list, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      runSpacing: 12,
      children: list.map((item) {
        return Container(
          padding: EdgeInsetsDirectional.only(start: 12.w,end: 8.w, top: 6.h , bottom: 6.h),
          decoration: BoxDecoration(
            color: Styles.PRIMARY_COLOR.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.name ?? "",
                style: AppTextStyles.w400.copyWith(
                  fontSize: 10,
                  color: Styles.PRIMARY_COLOR,
                ),
              ),
              4.sw,
              InkWell(
                onTap: () => onRemove(item),
                child: Images(
                  image: Assets.svgs.fillCloseCircle.path,
                  color: Styles.PRIMARY_COLOR,
                  width: 18,
                  height: 18,
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
