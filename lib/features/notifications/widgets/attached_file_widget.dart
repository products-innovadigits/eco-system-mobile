import 'package:core_package/core/utility/export.dart';

class AttachedFileWidget extends StatelessWidget {
  const AttachedFileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.color.surfaceContainer,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: context.color.outline),
          ),
          child: Images(
            image: Assets.svgs.documentText.path,
            width: 16.w,
            height: 16.h,
            color: context.color.primary,
          ),
        ),
        8.sw,
        Text('ملف مرفق', style: context.textTheme.bodySmall),
        4.sw,
        Text(
          '(2 MB)',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.color.outlineVariant,
          ),
        ),
      ],
    );
  }
}
