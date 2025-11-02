import 'package:pms_system/project_report/widgets/custom_info_container_widget.dart';

import '../../project_details/widgets/output_card_widget.dart';
import '../../shared/pms_exports.dart';

class ProjectReportOutputs extends StatelessWidget {
  final List<MobileOutputsSummaryModel> outputsSummary;

  const ProjectReportOutputs({super.key, required this.outputsSummary});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.the_outputs),
      withExpanded: false,
      withMargin: false,
      action: CustomInfoContainerWidget(
        title:
            '${outputsSummary.length} ${allTranslations.text(LocaleKeys.outputs)}',
        color: context.color.secondary,
      ),
      child: ListAnimator(
        scroll: false,
        separatorPadding: 8,
        data: outputsSummary
            .map(
              (output) => output.key != 'total'
                  ? OutputCardWidget(output: output)
                  : const SizedBox.shrink(),
            )
            .toList(),
      ),
    );
  }
}
