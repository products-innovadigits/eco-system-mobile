import 'package:core_package/core/utility/export.dart';

class CandidateDataSection extends StatelessWidget {
  const CandidateDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'السعودية',
          style: context.textTheme.labelSmall
              ?.copyWith(color: context.color.outlineVariant , fontSize: 10),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Icon(Icons.circle,
              color: context.color.outlineVariant, size: 4),
        ),
        Text(
          'خبرة ٥ سنين',
          style: context.textTheme.labelSmall
              ?.copyWith(color: context.color.outlineVariant , fontSize: 10),
        ),
        const Spacer(),
        Text(
          '\$ غير متوفر .',
          style: context.textTheme.labelSmall
              ?.copyWith(color: context.color.secondary , fontSize: 10),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child:
          Icon(Icons.circle, color: context.color.secondary, size: 4),
        ),
        Text(
          'اسبوعين',
          style: context.textTheme.labelSmall
              ?.copyWith(color: context.color.secondary , fontSize: 10),
        ),
      ],
    );
  }
}
