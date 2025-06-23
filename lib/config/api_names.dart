abstract class ApiNames {
  // static const login = "Auth/Login";
  static const login = "login";

  static const objectActivePercentage = "Dashboard/ObjectActivePersantge";
  static const objectActiveCategorized = "ObjectActive/Categorized";

  static const objectives = "ObjectActive";
  static const strategicAxis = "ObjectActive/GetStrategicAxis";
  static String objectiveDetails(id) => "ObjectActive/$id";
  static const objectiveKPIS = "KPIS/GetKpiByObjectActive";
  static const objectiveInitiatives = "Initiatives/ByObjectActive";
  static String objectiveChartData(id, time) => "ObjectActive/$id/Chart/$time";

  static const ProjectProgress = "ObjectActive/Categorized";
  static const ProjectCategoriesProgress = "ProjectCategory/CategoriesProgress";
  static const projects = "Project";
  static const projectPriorityLevels = "Project/PeriortyLevels";
  static String projectDetails(id) => "Project/$id";

  // Jobs APIs ====================
  static const jobs = "chances";

  // Talent Pool APIs ====================
  static const talents = "candidates";
  static const exportZipFile = "candidates/export-resumes";
  static const exportExcelFile = "candidates/export-resumes-excel";
  static const assignCandidatesToJobs = "candidates/bulk-assign-to-job";
  static String candidateDetails(id) => "candidates/$id";
  // Filters
  static const tags = "tags/get-all";
  static const sortingList = "candidates/sorting-list";
}
