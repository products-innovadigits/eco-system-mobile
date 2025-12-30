import 'package:pms_system/core/utility/pms_exports.dart';

import 'output_card_widget.dart';

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
