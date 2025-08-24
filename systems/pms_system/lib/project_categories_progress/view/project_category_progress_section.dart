import 'package:pms_system/shared/pms_exports.dart';

class ProjectCategoryProgressSection extends StatelessWidget {
  final bool isPmsHome;

  const ProjectCategoryProgressSection({super.key, this.isPmsHome = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectCategoriesProgressBloc()..add(Click()),
      child: BlocBuilder<ProjectCategoriesProgressBloc, AppState>(
        builder: (context, state) {
          return switch (state) {
            // ── Loading ─────────────────────────
            Loading() => const CustomShimmerContainer(),

            // ── Done ────────────────────────────
            Done(:final list) => _CategoriesChart(
              data:
                  list as List<ProjectCategoriesProgressModel>? ??
                  <ProjectCategoriesProgressModel>[],
              isPmsHome: isPmsHome,
            ),

            // ── Empty ───────────────────────────
            Empty() => const EmptyContainer(),

            // ── Error / fallback ────────────────
            _ => MainCardWidget(
              title: allTranslations.text(
                LocaleKeys.project_progress_rate_in_each_category,
              ),
              child: TryAgainWidget(
                onTryAgain: () {
                  context.read<ProjectCategoriesProgressBloc>().add(Click());
                },
              ),
            ),
          };
        },
      ),
    );
  }
}

class _CategoriesChart extends StatelessWidget {
  final List<ProjectCategoriesProgressModel> data;
  final bool isPmsHome;

  const _CategoriesChart({required this.data, required this.isPmsHome});

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
            title: allTranslations.text(
              LocaleKeys.project_progress_rate_in_each_category,
            ),
            withView: false,
          ),
          Divider(color: context.color.outline),
          SizedBox(
            height: isPmsHome ? data.length * 30.h : 250.h,
            child: SingleChildScrollView(
              child: SizedBox(
                height: isPmsHome ? data.length * 60.h : 250.h,
                child: ProjectCategoriesChart(data: data, isPmsHome: isPmsHome),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
