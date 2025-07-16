import 'package:core_package/core/utility/export.dart';

class ReviewProjectWidget extends StatelessWidget {
  const ReviewProjectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: context.color.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.color.outline),
          ),
          child: Center(
            child: Text(
              'مراجعة حالة المشروع',
              style: context.textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }
}
