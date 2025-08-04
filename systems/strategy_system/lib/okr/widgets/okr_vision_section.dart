import 'package:core_system/core/utility/export.dart';

class OkrVisionSection extends StatelessWidget {
  final String visionTitle;

  const OkrVisionSection({
    super.key,
    required this.visionTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: context.color.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Images(image: Assets.svgs.visionSquare.path , width: 22.w),
              8.sw,
              Expanded(
                child: Text(
                  visionTitle,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.color.secondary,
                  ),
                ),
              ),
              16.sw,
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.color.secondary.withValues(alpha: 0.2),
                ),
                child: Text(
                  '3',
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
