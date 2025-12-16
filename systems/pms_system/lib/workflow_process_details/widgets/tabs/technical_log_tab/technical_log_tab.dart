import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/bloc/history_tab_bloc.dart';
import 'package:pms_system/workflow_process_details/model/history_model.dart';
import 'package:pms_system/workflow_process_details/widgets/tabs/technical_log_tab/technical_log_timeline_card.dart';

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
      create: (context) => HistoryTabBloc()
        ..add(
          Click(arguments: {'processId': processId, 'projectId': projectId}),
        ),
      child: BlocBuilder<HistoryTabBloc, AppState>(
        builder: (context, state) {
          return switch (state) {
            // ── Loading ─────────────────────────
            Loading() ||
            Start() => ShimmerCardsList(itemCount: 3, cardHeight: 200),

            // ── Done ────────────────────────────
            Done(:final HistoryResponseModel model) => ListView.separated(
              itemCount: model.data!.length,
              itemBuilder: (context, index) {
                final historyItem = model.data![index];
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
            Empty() => const EmptyContainer(),

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
