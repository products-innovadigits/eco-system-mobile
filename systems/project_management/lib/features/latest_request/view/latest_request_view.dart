import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/pms_exports.dart';
import 'package:project_management/shared/widgets/pms_bottom_nav_bar.dart';

class LatestRequestView extends StatefulWidget {
  const LatestRequestView({super.key});

  @override
  State<LatestRequestView> createState() => _LatestRequestViewState();
}

class _LatestRequestViewState extends State<LatestRequestView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Clear filters when entering the view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        LatestRequestFiltrationCubit.instance.clearFilters();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LatestRequestSortingCubit>(
          create: (context) =>
              LatestRequestSortingCubit(repo: projectManagementSl()),
        ),
        BlocProvider<LatestRequestFiltrationCubit>(
          create: (context) =>
              LatestRequestFiltrationCubit(repo: projectManagementSl()),
        ),
        BlocProvider<LatestRequestCubit>(
          create: (context) =>
              LatestRequestCubit(repo: projectManagementSl())
                ..getLatestRequest(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final cubit = context.read<LatestRequestCubit>();
          final sortingCubit = context.read<LatestRequestSortingCubit>();
          return Scaffold(
            appBar: LatestRequestAppBarWidget(
              cubit: cubit,
              sortingCubit: sortingCubit,
            ),
            body: SafeArea(
              child: BlocBuilder<LatestRequestCubit, LatestRequestState>(
                builder: (context, state) {
                  return switch (state) {
                    // Loading first page
                    LatestRequestLoading() => const ShimmerCardsList(),

                    // Handle loaded state with data models
                    LatestRequestLoaded(
                      :final requests,
                      :final isLoadingMore,
                    ) =>
                      RefreshIndicator(
                        onRefresh: () async {
                          await context
                              .read<LatestRequestCubit>()
                              .refreshLatestRequest();
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListAnimator(
                                customPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                                separatorPadding: 8.h,
                                data: requests
                                    .map(
                                      (request) => RequestCardWidget(
                                        requestItem: request,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            CustomLoading(
                              isTextLoading: true,
                              loading: isLoadingMore,
                            ),
                          ],
                        ),
                      ),

                    // Empty
                    LatestRequestEmpty(:final isInitial) => _HandleEmptyList(
                      initial: isInitial,
                      cubit: cubit,
                    ),

                    // Error or fallback
                    _ => _HandleErrorState(cubit: cubit),
                  };
                },
              ),
            ),
            bottomNavigationBar: PmsBottomNavBar(
              index: _selectedIndex,
              isSubPage: true,
              onSelect: (index) {
                if (_selectedIndex != index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class _HandleEmptyList extends StatelessWidget {
  final bool? initial;
  final LatestRequestCubit cubit;

  const _HandleEmptyList({required this.initial, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.6,
      child: EmptyContainer(
        txt: initial == true
            ? null
            : (cubit.searchTEC.text.isEmpty)
            ? allTranslations.text(LocaleKeys.there_is_no_data)
            : '${allTranslations.text(LocaleKeys.no_projects_match)} \' ${cubit.searchTEC.text} \'',
      ),
    );
  }
}

class _HandleErrorState extends StatelessWidget {
  final LatestRequestCubit cubit;

  const _HandleErrorState({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await cubit.refreshLatestRequest();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: context.h * 0.6, child: const ErrorContainer()),
      ),
    );
  }
}
