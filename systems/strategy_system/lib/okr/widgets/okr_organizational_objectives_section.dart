import 'package:strategy_system/okr/model/okr_model.dart';
import 'package:strategy_system/okr/widgets/key_results_list_widget.dart';

import '../../shared/strategy_exports.dart';

class OkrOrganizationalObjectivesSection extends StatefulWidget {
  final List<OkrObjectivesModel> objectivesList;

  const OkrOrganizationalObjectivesSection({
    super.key,
    required this.objectivesList,
  });

  @override
  State<OkrOrganizationalObjectivesSection> createState() =>
      _OkrOrganizationalObjectivesSectionState();
}

class _OkrOrganizationalObjectivesSectionState
    extends State<OkrOrganizationalObjectivesSection> {
  List<bool> expansionStates = [];

  @override
  void initState() {
    super.initState();
    expansionStates = List.generate(
      widget.objectivesList.length,
      (index) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          allTranslations.text(LocaleKeys.organizational_objectives),
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.h),
        ...List.generate(
          widget.objectivesList.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ExpansionTile(
              onExpansionChanged: (bool expanded) {
                setState(() {
                  expansionStates[i] = expanded;
                });
              },
              tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
              expansionAnimationStyle: AnimationStyle(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
              title: RichText(
                text: TextSpan(
                  text: '${widget.objectivesList[i].title} ',
                  style: context.textTheme.labelSmall,
                  children: [
                    TextSpan(
                      text: '(${widget.objectivesList[i].keyResults?.length})',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.color.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: expansionStates[i]
                      ? context.color.secondary
                      : context.color.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: expansionStates[i]
                      ? context.color.secondary
                      : context.color.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              iconColor: context.color.secondary,
              collapsedIconColor: context.color.outlineVariant,
              collapsedTextColor: context.color.onSurface,
              leading: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: expansionStates[i]
                      ? context.color.primary
                      : context.color.secondary.withValues(alpha: 0.1),
                ),
                child: Images(
                  image: Assets.svgs.target.path,
                  width: 14.w,
                  color: expansionStates[i]
                      ? context.color.surfaceContainer
                      : null,
                ),
              ),
              visualDensity: VisualDensity.compact,
              children: <Widget>[
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: 16.w,
                    start: 46.w,
                    bottom: 8.h,
                  ),
                  child: KeyResultsListWidget(
                    keyResults: widget.objectivesList[i].keyResults ?? [],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
