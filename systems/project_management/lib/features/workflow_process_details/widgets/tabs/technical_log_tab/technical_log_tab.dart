import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

class TechnicalLogTab extends StatelessWidget {
  final int processId;
  final int projectId;

  const TechnicalLogTab({
    super.key,
    required this.processId,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HistoryTabBloc(repo: projectManagementSl())
            ..add(LoadHistoryData(processId: processId, projectId: projectId)),
      child: BlocBuilder<HistoryTabBloc, HistoryTabState>(
        builder: (context, state) {
          return switch (state) {
            // ── Loading ─────────────────────────
            HistoryTabLoading() || HistoryTabInitial() => ShimmerCardsList(
              itemCount: 3,
              cardHeight: 200,
            ),

            // ── Loaded ────────────────────────────
            HistoryTabLoaded(:final historyData) => ListView.separated(
              itemCount: historyData.data!.length,
              itemBuilder: (context, index) {
                final historyItem = historyData.data![index];
                return TechnicalLogTimelineCard(
                  processGroup: historyItem.stepGroup?.groupName ?? "",
                  stageName: historyItem.name ?? "",
                  employee: historyItem.responsibleUser?.fullName ?? "",
                  time: FormattersHelper.formatTime(historyItem.lastChangeTime),
                  commenter: historyItem.responsibleUser?.fullName ?? "",
                  comments: historyItem.stepComments ?? [],
                  attachments: historyItem.slicesData ?? [],
                  date: FormattersHelper.formatDate(
                    historyItem.lastChangeTime,
                    isDate: true,
                  ),
                  month: FormattersHelper.formatDate(
                    historyItem.lastChangeTime,
                    isMonth: true,
                  ),
                );
              },
              separatorBuilder: (context, index) => _TimelineDivider(),
            ),

            // ── Empty ───────────────────────────
            HistoryTabEmpty() => const EmptyContainer(),

            // ── Error / fallback ────────────────
            _ => EmptyContainer(
              txt: allTranslations.text(LocaleKeys.something_went_wrong),
              img: Assets.svgs.error.path,
            ),
          };
        },
      ),
    );
  }
}

class _TimelineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 14, bottom: 14, start: 42),
      height: 1,
      color: context.color.outline,
    );
  }
}
