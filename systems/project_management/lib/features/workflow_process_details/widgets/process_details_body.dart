import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/shared/widgets/shimmer/custom_details_shimmer_loading.dart';

class ProcessDetailsBody extends StatelessWidget {
  final int projectId;
  final int processId;

  const ProcessDetailsBody({
    super.key,
    required this.projectId,
    required this.processId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HeaderSection(),
        _ContentSection(projectId: projectId, processId: processId),
      ],
    );
  }
}

bool _isLoading(ProcessDetailsState state) =>
    state is ProcessDetailsInitial ||
    state is GroupStepsLoading ||
    state is ProcessStarting;

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    // Every load ends in a different state type than it started with, so this
    // rebuilds with the fresh data; tab switches re-emit the same type.
    return BlocBuilder<ProcessDetailsBloc, ProcessDetailsState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        final data = context.read<ProcessDetailsBloc>().stageDocsData;
        return (_isLoading(state) || data == null)
            ? const SizedBox.shrink()
            : ProcessHeaderCard(data: data);
      },
    );
  }
}

class _ContentSection extends StatelessWidget {
  final int projectId;
  final int processId;

  const _ContentSection({required this.projectId, required this.processId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProcessDetailsBloc, ProcessDetailsState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType ||
          (previous is GroupStepsLoaded &&
              current is GroupStepsLoaded &&
              previous.processDetails != current.processDetails),
      builder: (context, state) {
        if (_isLoading(state)) return const CustomDetailsShimmerLoading();

        // An empty or failed group steps result is handled inside the follow
        // process tab, the rest of the screen stays usable.
        if (state is GroupStepsLoaded ||
            state is GroupStepsEmpty ||
            state is GroupStepsReloading) {
          return _ProcessContent(projectId: projectId, processId: processId);
        }

        // Only reached when nothing at all could be loaded. Expanded like the
        // content and the shimmer: EmptyContainer sizes itself off the screen
        // height, so as a plain column child it overflows the header.
        return Expanded(
          child: EmptyContainer(
            txt:
                (state is GroupStepsFailure ? state.message : null) ??
                allTranslations.text(LocaleKeys.something_went_wrong),
            img: Assets.svgs.error.path,
            onRetry: () => context.read<ProcessDetailsBloc>().add(
              LoadGroupSteps(processId: processId, projectId: projectId),
            ),
          ),
        );
      },
    );
  }
}

class _ProcessContent extends StatelessWidget {
  final int projectId;
  final int processId;

  const _ProcessContent({required this.projectId, required this.processId});

  @override
  Widget build(BuildContext context) {
    // Only this part depends on the selected tab, so switching tabs doesn't
    // rebuild the header.
    final selectedTab = context.select(
      (ProcessDetailsBloc bloc) => bloc.selectedTab,
    );

    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 12.h),
          const ProcessDetailsTabsSection(),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildTab(context, selectedTab),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, ProcessTabsEnum tab) {
    final bloc = context.read<ProcessDetailsBloc>();

    return switch (tab) {
      ProcessTabsEnum.followProcess => FollowProcessTab(
        processList: bloc.getGroupStepsModel?.data ?? const [],
        hasError: bloc.groupStepsFailed,
        errorMessage: bloc.groupStepsErrorMessage,
        isReloading: bloc.isGroupStepsReloading,
        onRetry: () => bloc.add(
          ReloadGroupSteps(processId: processId, projectId: projectId),
        ),
      ),
      ProcessTabsEnum.stageDocs => StageDocsTab(
        processName: bloc.stageDocsData?.processTitle ?? '',
        documents: bloc.stageDocsData?.currentStep?.stepDocuments ?? const [],
      ),
      ProcessTabsEnum.history => TechnicalLogTab(
        processId: processId,
        projectId: projectId,
      ),
      _ => ActionsTab(processId: processId, projectId: projectId),
    };
  }
}
