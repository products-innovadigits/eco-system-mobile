import 'package:core_package/core/utility/export.dart';

class StatusWidget extends StatelessWidget {
  final String status;
  const StatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color:
            context.color.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
            ),
          ),
          child: Center(
              child: Text(
                status,
                style: AppTextStyles.w400.copyWith(
                    fontSize: 10, color: context.color.secondary),
              )),
        ),
      ],
    );
  }
}
