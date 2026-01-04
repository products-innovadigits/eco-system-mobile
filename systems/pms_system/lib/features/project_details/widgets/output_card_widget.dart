import 'package:pms_system/core/utility/pms_exports.dart';

class OutputCardWidget extends StatelessWidget {
  final MobileOutputsSummaryModel output;

  const OutputCardWidget({super.key, required this.output});

  @override
  Widget build(BuildContext context) {
    final color = Color(
      int.parse((output.background ?? '#000000').replaceFirst('#', '0xff')),
    );
    final titles = output.titles ?? [];
    final titlesLength = titles.length;
    final titleText = titlesLength > 10
        ? allTranslations.text(LocaleKeys.output)
        : allTranslations.text(LocaleKeys.outputs);

    return CustomExpansionCard(
      title: output.label ?? '',
      withMargin: false,
      withExpanded: false,
      action: CustomInfoContainerWidget(
        title: '$titlesLength $titleText',
        color: color,
      ),
      child: titles.isNotEmpty
          ? ListAnimator(
              scroll: false,
              data: titles
                  .map(
                    (output) => Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: color.withValues(alpha: 0.1),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              output,
                              style: context.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )
          : Center(child: Text(allTranslations.text(LocaleKeys.no_outputs))),
    );
  }
}
