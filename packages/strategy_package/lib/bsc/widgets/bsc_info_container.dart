import 'package:core_package/core/utility/export.dart';

class BscInfoContainer extends StatelessWidget {
  final Color color;
  final String title;
  final String icon;
  final String? description;
  final Widget? descriptionWidget;

  const BscInfoContainer({
    super.key,
    required this.color,
    required this.title,
    required this.icon,
    this.description,
    this.descriptionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Images(image: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelMedium?.copyWith(color: color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                    descriptionWidget ??
                        Text(description ?? '', style: context.textTheme.bodySmall),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
