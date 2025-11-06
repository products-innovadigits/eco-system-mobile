abstract class ApiNames {
  static const login = "Auth/Login";
  // static const login = "login";
  static const strategyLogin = "Auth/AuthenticateExternalUserAsync";
  static const colorScheme = "";

  // Strategy APIs ====================
  static const objectActivePercentage = "Dashboard/ObjectActivePersantge";
  static const objectActiveCategorized = "ObjectActive/Categorized";
  static const objectives = "ObjectActive";
  static const strategicAxis = "ObjectActive/GetStrategicAxis";
  static String objectiveDetails(id) => "ObjectActive/$id";
  static const objectiveKPIS = "KPIS/GetKpiByObjectActive";
  static const objectiveInitiatives = "Initiatives/ByObjectActive";
  static const bsc = "Dashboard/getDashboardBalance";
  static String objectiveChartData(id, time) => "ObjectActive/$id/Chart/$time";

  // Project Management APIs ====================
  static const ProjectProgress = "Project/GetProgressCountPrestange";
  static const ProjectCategoriesProgress = "ProjectCategory/CategoriesProgress";
  static const projects = "Project/GetFilteredProjects";
  // static const projects = "Project";
  static const projectPriorityLevels = "Project/PeriortyLevels";
  static const projectFilterOptions = "Project/filter-options";
  static const projectSortingOptions = "Project/GetProjectSortOptionsAsync";
  static String projectDetails(id) => "Project/$id";
  static String projectReport(id) => "Project/mobile-report/$id";
  static String projectGeneralProgressSummary(id) =>
      "Project/$id/progress-summary";
  static String workflowProcessDetails = "WorkFlow/GroupSteps";
  static String currentNextSteps = "WorkFlow/CurrentAndNext";
  // static String stageDocsData = "DocumentData";
  static String documentComment = "DocumentComment";
  static String documentCommentActions(id) => "DocumentComment/$id";
  static String projectProcessTechnicalLog = "ProjectProcess/TechnicalLog";
  static String projectStepComment = "ProjectStepComment";
  static String projectProcessNext = "ProjectProcess/next";
  static String projectProcessStart = "WorkFlow/Run";

  // Jobs APIs ====================
  static const jobs = "chances";

  // Talent Pool APIs ====================
  static const talents = "candidates";
  static const exportZipFile = "candidates/export-resumes";
  static const exportExcelFile = "candidates/export-resumes-excel";
  static const assignCandidatesToJobs = "candidates/bulk-assign-to-job";
  static String candidateDetails(id) => "candidates/$id";

  // Filters ===================================
  static const tags = "tags/get-all";
  static const sortingList = "candidates/sorting-list";
}
