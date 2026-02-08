import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectTimelineTab extends StatelessWidget {
  final DateTime projectStart;
  final DateTime projectEnd;

  const ProjectTimelineTab({
    super.key,
    required this.projectStart,
    required this.projectEnd,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsBloc, ProjectDetailsState>(
      buildWhen: (previous, current) {
        return current is ProjectTimelineLoaded ||
            current is ProjectTimelineLoading ||
            current is ProjectTimelineFailure ||
            current is ProjectDetailsLoaded;
      },
      builder: (context, state) {
        return switch (state) {
          // ── Loading ─────────────────────────
          ProjectTimelineLoading() => CustomShimmerContainer(),

          // ── Done ────────────────────────────
          ProjectTimelineLoaded(:final milestones) =>
            milestones.isEmpty
                ? const EmptyContainer(remain: 500)
                : ProjectTimeline(
                    milestonesList: milestones,
                    projectStart: projectStart,
                    projectEnd: projectEnd,
                  ),

          // ── ProjectDetailsLoaded state: check for cached milestones ──
          ProjectDetailsLoaded() => () {
            final bloc = context.read<ProjectDetailsBloc>();
            final cachedMilestones = bloc.cachedMilestones;
            if (cachedMilestones != null && cachedMilestones.isNotEmpty) {
              return ProjectTimeline(
                milestonesList: cachedMilestones,
                projectStart: projectStart,
                projectEnd: projectEnd,
              );
            }
            return const EmptyContainer();
          }(),

          // ── Error / fallback ────────────────
          _ => EmptyContainer(
            txt: allTranslations.text(LocaleKeys.something_went_wrong),
            img: Assets.svgs.error.path,
          ),
        };
      },
    );
  }
}

final List<MilestoneModel> demoMilestones = [
  MilestoneModel(
    id: 1,
    name: 'MS-1 إعداد الخطة الإستراتيجية',
    description: 'تحضير وصياغة الخطة الإستراتيجية 2026-2030',
    projectId: 10,
    startDate: DateTime(2025, 8, 1),
    endDate: DateTime(2025, 10, 20),
    subActivities: [
      SubActivityModel(
        id: 165,
        name: 'SA-1 جمع البيانات',
        description: 'جمع البيانات الأولية من الإدارات المختلفة.',
        activityId: 2,
        startDate: DateTime(2025, 8, 1),
        endDate: DateTime(2025, 8, 15),
        outputId: null,
        budgetValue: null,
        isWithOutput: false,
        isHaveBudget: false,
        isDelivered: false,
        updatedAt: DateTime(2025, 7, 7, 12, 58, 4),
      ),
      SubActivityModel(
        id: 166,
        name: 'SA-2 مراجعة لغوية',
        description: 'مراجعة لغوية للوثيقة.',
        activityId: 2,
        startDate: DateTime(2025, 8, 16),
        endDate: DateTime(2025, 9, 3),
        outputId: null,
        budgetValue: null,
        isWithOutput: false,
        isHaveBudget: false,
        isDelivered: false,
        updatedAt: DateTime(2025, 7, 7, 12, 58, 4),
      ),
      SubActivityModel(
        id: 167,
        name: 'SA-3 إنتاج وثيقة الخطة الإستراتيجية 2026-2030',
        description: 'إنتاج: وثيقة الخطة الإستراتيجية 2026-2030',
        activityId: 2,
        startDate: DateTime(2025, 9, 4),
        endDate: DateTime(2025, 10, 8),
        outputId: 49,
        budgetValue: 666667.0,
        isWithOutput: true,
        isHaveBudget: true,
        isDelivered: true,
        updatedAt: DateTime(2025, 7, 7, 12, 58, 4),
      ),
      SubActivityModel(
        id: 168,
        name: 'SA-4 مراجعة نهائية واعتماد',
        description: 'مراجعة نهائية للوثيقة واعتمادها.',
        activityId: 2,
        startDate: DateTime(2025, 10, 9),
        endDate: DateTime(2025, 10, 20),
        outputId: null,
        budgetValue: null,
        isWithOutput: false,
        isHaveBudget: false,
        isDelivered: false,
        updatedAt: DateTime(2025, 7, 8, 9, 0, 0),
      ),
    ],
  ),
  MilestoneModel(
    id: 2,
    name: 'MS-5 إعداد الخطة ',
    description: 'تحضير وصياغة الخطة  2025-2030',
    projectId: 10,
    startDate: DateTime(2025, 8, 10),
    endDate: DateTime(2025, 10, 10),
    subActivities: [
      SubActivityModel(
        id: 165,
        name: 'SA-1 جمع البيانات',
        description: 'جمع البيانات الأولية من الإدارات المختلفة.',
        activityId: 2,
        startDate: DateTime(2025, 8, 10),
        endDate: DateTime(2025, 8, 15),
        outputId: null,
        budgetValue: null,
        isWithOutput: false,
        isHaveBudget: false,
        isDelivered: false,
        updatedAt: DateTime(2025, 7, 7, 12, 58, 4),
      ),
      SubActivityModel(
        id: 166,
        name: 'SA-2 مراجعة لغوية',
        description: 'مراجعة لغوية للوثيقة.',
        activityId: 2,
        startDate: DateTime(2025, 8, 16),
        endDate: DateTime(2025, 10, 3),
        outputId: null,
        budgetValue: null,
        isWithOutput: false,
        isHaveBudget: false,
        isDelivered: false,
        updatedAt: DateTime(2025, 7, 7, 12, 58, 4),
      ),
    ],
  ),

  // Milestone تاني للتجربة (subActivities أقل من أو يساوي 2)
  MilestoneModel(
    id: 3,
    name: 'MS-2 تنفيذ الخطة',
    description: 'بدء تنفيذ الخطة الإستراتيجية',
    projectId: 10,
    startDate: DateTime(2025, 11, 1),
    endDate: DateTime(2026, 2, 28),
    subActivities: [
      SubActivityModel(
        id: 200,
        name: 'SA-1 إطلاق المرحلة الأولى',
        description: 'إطلاق المرحلة الأولى من التنفيذ.',
        activityId: 3,
        startDate: DateTime(2025, 11, 1),
        endDate: DateTime(2025, 12, 15),
        outputId: null,
        budgetValue: 1000000.0,
        isWithOutput: true,
        isHaveBudget: true,
        isDelivered: false,
        updatedAt: DateTime(2025, 7, 10, 10, 0, 0),
      ),
      SubActivityModel(
        id: 201,
        name: 'SA-2 متابعة وتقييم',
        description: 'متابعة وتنفيذ خطة التقييم.',
        activityId: 3,
        startDate: DateTime(2025, 12, 16),
        endDate: DateTime(2026, 2, 28),
        outputId: null,
        budgetValue: null,
        isWithOutput: false,
        isHaveBudget: false,
        isDelivered: false,
        updatedAt: DateTime(2025, 7, 10, 10, 30, 0),
      ),
    ],
  ),
];
