import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';

class JobDetailsWidget extends StatelessWidget {
  final bool? hasStatus;
  final String jobTitle;
  final String address;
  final String jobType;
  final String department;

  const JobDetailsWidget(
      {super.key,
      this.hasStatus = false,
      required this.jobTitle,
      required this.address,
      required this.jobType,
      required this.department});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              jobTitle,
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: context.color.onSurface),
            ),
            // if (hasStatus ?? false)
            //   Container(
            //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            //     decoration: BoxDecoration(
            //       color: Colors.green.withValues(alpha: 0.1),
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: Center(
            //         child: Text(
            //       'نشطة',
            //       style: AppTextStyles.w400
            //           .copyWith(fontSize: 10, color: Colors.green),
            //     )),
            //   )
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          '$jobType . $address . $department',
          style: context.textTheme.bodyMedium
              ?.copyWith(color: context.color.outlineVariant, fontSize: FontSizes.f10),
        ),
        Padding(
          padding: EdgeInsets.all(14.h),
          child: Divider(color: context.color.outline),
        ),
      ],
    );
  }
}
