import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/bloc/cycles_bloc.dart';
import 'package:pms_system/features/cycles/bloc/cycles_events.dart';
import 'package:pms_system/features/cycles/bloc/cycles_states.dart';
import 'package:pms_system/features/cycles/widgets/cycle_card.dart';

class CyclesBodyMobileLandscapeView extends StatelessWidget {
  final ScrollController scrollController;
  final TextEditingController searchController;

  const CyclesBodyMobileLandscapeView({
    super.key,
    required this.scrollController,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CyclesBloc>();
    return SafeArea(
      child: BlocBuilder<CyclesBloc, CyclesState>(
        builder: (context, state) {
          return switch (state) {
            CyclesLoading() => ShimmerCardsList(cardHeight: 200),
            CyclesLoaded(:final cycles, :final isLoadingMore) => Column(
              children: [
                Expanded(
                  child: ListAnimator(
                    controller: scrollController,
                    data: cycles
                        .map((cycle) => CycleCard(cycle: cycle))
                        .toList(),
                  ),
                ),
                CustomLoading(isTextLoading: true, loading: isLoadingMore),
              ],
            ),
            CyclesEmpty(:final isInitial) => _HandleEmptyList(
              initial: isInitial,
              searchController: searchController,
              bloc: bloc,
            ),
            _ => _HandleErrorState(bloc: bloc),
          };
        },
      ),
    );
  }
}

class _HandleEmptyList extends StatelessWidget {
  final bool? initial;
  final TextEditingController searchController;
  final CyclesBloc bloc;

  const _HandleEmptyList({
    required this.initial,
    required this.searchController,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.6,
      child: EmptyContainer(
        txt: initial == true
            ? null
            : searchController.text.isEmpty
            ? allTranslations.text(LocaleKeys.no_cycles_found)
            : '${allTranslations.text(LocaleKeys.no_cycles_match)} \'${searchController.text}\'',
      ),
    );
  }
}

class _HandleErrorState extends StatelessWidget {
  final CyclesBloc bloc;

  const _HandleErrorState({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(const RefreshCycles());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: context.h * 0.6, child: const ErrorContainer()),
      ),
    );
  }
}
