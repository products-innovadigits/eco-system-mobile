import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class AvailableJobsSection extends StatefulWidget {
  const AvailableJobsSection({super.key});

  @override
  State<AvailableJobsSection> createState() => _AvailableJobsSectionState();
}

class _AvailableJobsSectionState extends State<AvailableJobsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<JobsBloc>().add(Click(arguments: SearchEngine()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobsBloc, AppState>(
      builder: (context, state) {
        return switch (state) {
          // ── Loading ─────────────────────────
          Loading() => CustomShimmerContainer(
            padding: EdgeInsets.only(top: 24.h),
          ),

          // ── Done ───────────────────────────
          Done() => _JobsCard(child: const JobsListSection(isHome: true)),

          // ── Empty (same inner card chrome as [JobCardWidget]) ──
          Empty() => _JobsCard(
            child: Text(
              allTranslations.text(LocaleKeys.no_available_jobs),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.color.onSurfaceVariant,
              ),
            ),
          ),

          // ── Default (error / other states) ─
          _ => _JobsCard(
            child: TryAgainWidget(
              onTryAgain: () {
                context.read<JobsBloc>().add(Click(arguments: SearchEngine()));
              },
            ),
          ),
        };
      },
    );
  }
}

class _JobsCard extends StatelessWidget {
  final Widget child;

  const _JobsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            title: allTranslations.text(LocaleKeys.available_jobs),
            withView: true,
            onViewTap: () {
              context.read<JobsBloc>().add(Click(arguments: SearchEngine()));
              CustomNavigator.push(Routes.JOBS);
            },
          ),
          Divider(color: context.color.outline),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}
