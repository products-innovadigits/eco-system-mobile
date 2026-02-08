import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectOutputsBottomSheet extends StatelessWidget {
  final List<MobileOutputsSummaryModel> outputsSummary;

  const ProjectOutputsBottomSheet({super.key, required this.outputsSummary});

  @override
  Widget build(BuildContext context) {
    return ListAnimator(
      data: outputsSummary
          .map(
            (output) => output.key != 'total'
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: OutputCardWidget(output: output),
                  )
                : const SizedBox.shrink(),
          )
          .toList(),
    );
  }
}
