import 'package:pms_system/shared/pms_exports.dart';

import 'output_card_widget.dart';

class ProjectOutputsBottomSheet extends StatelessWidget {
  final List<MobileOutputsSummaryModel> outputsSummary;

  const ProjectOutputsBottomSheet({super.key, required this.outputsSummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(title: allTranslations.text(LocaleKeys.outputs)),
        const SizedBox(height: 24),
        ListAnimator(
          data: outputsSummary
              .map(
                (output) => output.key != 'total'
                    ? OutputCardWidget(output: output)
                    : const SizedBox.shrink(),
              )
              .toList(),
        ),
      ],
    );
  }
}
