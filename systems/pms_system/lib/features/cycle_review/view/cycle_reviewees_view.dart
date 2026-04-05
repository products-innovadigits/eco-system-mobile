import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_bloc.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_events.dart';
import 'package:pms_system/features/cycle_review/bloc/cycle_review_states.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';
import 'package:pms_system/features/cycle_review/widgets/cycle_reviewees_shimmer.dart';
import 'package:pms_system/features/cycle_review/widgets/reviewee_card.dart';

class CycleRevieweesView extends StatefulWidget {
  final int cycleId;

  const CycleRevieweesView({super.key, required this.cycleId});

  @override
  State<CycleRevieweesView> createState() => _CycleRevieweesViewState();
}

class _CycleRevieweesViewState extends State<CycleRevieweesView> {
  late CycleReviewBloc _bloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = CycleReviewBloc(repo: pmsSl())
      ..add(
        LoadReviewees(cycleId: widget.cycleId, searchEngine: SearchEngine()),
      );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _bloc.add(const LoadMoreReviewees());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CycleReviewBloc>.value(
      value: _bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: allTranslations.text(LocaleKeys.reviewers),
          withCancelBtn: false,
        ),
        body: BlocBuilder<CycleReviewBloc, CycleReviewState>(
          builder: (context, state) {
            return switch (state) {
              CycleReviewInitial() ||
              RevieweesLoading() => const CycleRevieweesShimmer(),
              RevieweesLoaded(:final reviewees, :final isLoadingMore) =>
                _RevieweesList(
                  cycleId: widget.cycleId,
                  reviewees: reviewees,
                  isLoadingMore: isLoadingMore,
                  scrollController: _scrollController,
                ),
              RevieweesEmpty() => Center(
                child: EmptyContainer(
                  txt: allTranslations.text(LocaleKeys.there_is_no_data),
                ),
              ),
              RevieweesFailure(:final message) => Center(
                child: EmptyContainer(txt: message),
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _RevieweesList extends StatelessWidget {
  final int cycleId;
  final List<CycleRevieweeModel> reviewees;
  final bool isLoadingMore;
  final ScrollController scrollController;

  const _RevieweesList({
    required this.cycleId,
    required this.reviewees,
    required this.isLoadingMore,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: reviewees.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        if (index == reviewees.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        return ReviewCard(
          review: reviewees[index],
          initiallyExpanded: false,
          cycleId: cycleId,
        );
      },
    );
  }
}
