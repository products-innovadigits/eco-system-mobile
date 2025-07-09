
import 'package:core_package/core/utility/export.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  final VoidCallback onCheck;
  final bool isChecked;
  const CustomCheckBoxWidget({super.key, required this.onCheck, this.isChecked = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onCheck();
      },
      child: Container(
        width: 24.w,
        height: 24.w,
        padding: EdgeInsets.all(4.w),
        child: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: context.color.secondary),
            color: isChecked ? context.color.secondary : context.color.surfaceContainer,
          ),
          child: isChecked
              ? Images(image: Assets.svgs.check.path)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
