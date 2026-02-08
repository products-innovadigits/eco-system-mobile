import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectReportInitiativesAndKpis extends StatelessWidget {
  final List<RelatedItemModel> initiativesAndKpis;

  const ProjectReportInitiativesAndKpis({
    super.key,
    required this.initiativesAndKpis,
  });

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.initiatives_and_kpis),
      withMargin: false,
      // withExpanded: false,
      leadingWidget: Images(
        image: Assets.svgs.file.path,
        color: Colors.black,
        width: 24,
      ),
      child: initiativesAndKpis.isNotEmpty
          ? Column(
              children: List.generate(initiativesAndKpis.length, (index) {
                final RelatedItemModel itemModel = initiativesAndKpis[index];
                return Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          itemModel.title ?? '',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: itemModel.type == 'kpi'
                                ? context.color.tertiary
                                : context.color.secondary,
                          ),
                        ),
                      ),
                      CustomInfoContainerWidget(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 2,
                        ),
                        color: itemModel.type == 'kpi'
                            ? context.color.tertiary
                            : context.color.secondary,
                        radius: 16,
                        title: allTranslations.text(itemModel.type ?? ''),
                      ),
                    ],
                  ),
                );
              }),
            )
          : Center(
              child: Text(allTranslations.text(LocaleKeys.there_is_no_data)),
            ),
    );
  }
}
