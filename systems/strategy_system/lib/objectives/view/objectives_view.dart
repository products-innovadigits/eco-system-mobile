import 'package:strategy_system/objectives/widgets/filter/objectives_filter_bottomsheet.dart';

import '../../shared/strategy_exports.dart';

class ObjectivesView extends StatelessWidget {
  const ObjectivesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ObjectivesBloc()..add(Click(arguments: SearchEngine())),
      child: BlocBuilder<ObjectivesBloc, AppState>(
        builder: (context, state) {
          return switch (state) {
            // ── Loading ─────────────────────────────
            Loading() => const ShimmerCardsList(),

            // ── Done ────────────────────────────────
            Done(:final cards, :final loading) => Column(
              children: [
                Expanded(
                  child: ListAnimator(
                    customPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    controller: context.read<ObjectivesBloc>().scrollController,
                    data: cards,
                  ),
                ),
                CustomLoading(isTextLoading: true, loading: loading),
              ],
            ),

            // ── Empty  ──────────────────────
            Empty() => EmptyContainer(),

            // ── Fallback ────────────────────────────
            _ => EmptyContainer(
              txt: allTranslations.text(LocaleKeys.oops),
              desc: allTranslations.text(LocaleKeys.something_went_wrong),
            ),
          };
        },
      ),
    );
  }
}
