import 'package:pms_system/core/utility/pms_exports.dart';

class EmployeeLearningDetailsHeader extends StatelessWidget {
  const EmployeeLearningDetailsHeader({
    super.key,
    required this.employeeName,
    required this.onRequestLearningPath,
  });

  final String employeeName;
  final VoidCallback onRequestLearningPath;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            employeeName,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.color.onSurface,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: CustomBtn(
            text: allTranslations.text(LocaleKeys.request_for_learning_path),
            onPressed: onRequestLearningPath,
            height: 44,
            fontSize: FontSizes.f14,
          ),
        ),
      ],
    );
  }
}
