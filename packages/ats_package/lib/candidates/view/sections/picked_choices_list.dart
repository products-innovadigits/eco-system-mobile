import 'package:core_package/core/utility/export.dart';

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
            color: context.color.onSurfaceVariant.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.name ?? "",
                style: context.textTheme.bodySmall,
              ),
              4.sw,
              InkWell(
                onTap: () => onRemove(item),
                child: Images(
                  image: Assets.svgs.fillCloseCircle.path,
                  color: context.color.primary,
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
