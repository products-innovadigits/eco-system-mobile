import 'package:ats_system/candidates/view/sections/total_candidates_section.dart';
import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class TalentPoolSection extends StatelessWidget {
  const TalentPoolSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TalentPoolBloc()..add(Click(arguments: SearchEngine())),
      child: BlocBuilder<TalentPoolBloc, AppState>(
        builder: (context, state) {
          final talentPoolBloc = context.read<TalentPoolBloc>();

          return switch (state) {
            // ── Loading ──────────────────────────────────────────────
            Loading() => CustomShimmerContainer(
              height: context.h * 0.2,
              width: context.w,
              padding: EdgeInsets.only(top: 12.h),
            ),

            // ── Error ────────────────────────────────────────────────
            Done() => _TalentPoolCard(
              child: TotalCandidatesSection(
                talentsList: talentPoolBloc.talentsList,
                candidatesCount: talentPoolBloc.candidatesCount ?? 0,
              ),
            ),

            // ── Empty ────────────────────────────────────────────────
            Empty() => const EmptyContainer(),

            // ── Default (error/unknown) ─────────────────────────────
            _ => _TalentPoolCard(
              child: TryAgainWidget(
                onTryAgain: () {
                  talentPoolBloc.add(Click(arguments: SearchEngine()));
                },
              ),
            ),
          };
        },
      ),
    );
  }
}

class _TalentPoolCard extends StatelessWidget {
  final Widget child;

  const _TalentPoolCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AtsFiltrationBloc>().reset();
        context.read<AtsFiltrationBloc>().add(Click());
        CustomNavigator.push(Routes.TALENT_POOL);
      },
      child: Container(
        width: context.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.color.outline),
        ),
        child: Column(
          children: [
            SectionTitle(
              title: allTranslations.text(LocaleKeys.talent_pool),
              subText: allTranslations.text(
                LocaleKeys.candidate_with_future_potential,
              ),
              icon: Assets.svgs.tripleUser.path,
              onViewTap: () {}, // kept as-is
            ),
            Divider(color: context.color.outline),
            SizedBox(height: 12.h),
            child,
          ],
        ),
      ),
    );
  }
}
