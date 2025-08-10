class ProjectItem {
  final int startMonth, startWeek;
  final int endMonth, endWeek;
  final int? preferredRow;
  final String? name;
  final List<ProjectItem>? subProjects ;

  const ProjectItem({
    required this.startMonth,
    required this.startWeek,
    required this.endMonth,
    required this.endWeek,
    this.subProjects,
    this.preferredRow,
    this.name,
  })  : assert(startMonth >= 1 && startMonth <= 12),
        assert(endMonth >= 1 && endMonth <= 12),
        assert(startWeek >= 1 && startWeek <= 4),
        assert(endWeek >= 1 && endWeek <= 4);
}
