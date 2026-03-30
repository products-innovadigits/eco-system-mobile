abstract class ApiNames {
  static const login = "Auth/Login";
  static const pmsLogin = "login";
  static const strategyLogin = "Auth/AuthenticateExternalUserAsync";
  static const colorScheme = "";

  // Strategy APIs ====================
  static const objectActivePercentage = "Dashboard/ObjectActivePersantge";
  static const objectActiveCategorized = "ObjectActive/Categorized";
  static const objectives = "ObjectActive";
  static const strategicAxis = "ObjectActive/GetStrategicAxis";
  static String objectiveDetails(int id) => "ObjectActive/$id";
  static const objectiveKPIS = "KPIS/GetKpiByObjectActive";
  static const objectiveInitiatives = "Initiatives/ByObjectActive";
  static const bsc = "Dashboard/getDashboardBalance";
  static String objectiveChartData(int id, String time) =>
      "ObjectActive/$id/Chart/$time";

  // Project Management APIs ====================
  static const projectProgress = "Project/GetProgressCountPrestange";
  static const projectCategoriesProgress = "ProjectCategory/CategoriesProgress";
  static const projects = "Project/GetFilteredProjects";
  // static const projects = "Project";
  static const projectPriorityLevels = "Project/PeriortyLevels";
  static const projectFilterOptions = "Project/filter-options";
  static const projectSortingOptions = "Project/GetProjectSortOptionsAsync";
  static String projectDetails(int id) => "Project/$id";
  static String projectReport(int id) => "Project/mobile-report/$id";
  static String projectGeneralProgressSummary(int id) =>
      "Project/$id/progress-summary";
  static String projectTimeline(int id) =>
      "ProjectTimeLine/GetAllActivitiesByProjectId/$id";
  static String workflowGroupSteps = "WorkFlow/GroupSteps";
  static String currentNextSteps = "WorkFlow/CurrentAndNext_Mobile";
  // static String currentNextSteps = "WorkFlow/CurrentAndNext";
  static String currentStepDocs = "Documents/CurrentStepDocuments";
  // static String stageDocsData = "DocumentData";
  static String documentComment = "DocumentComment";
  static String documentCommentActions(int id) => "DocumentComment/$id";
  static String projectProcessTechnicalLog = "ProjectProcess/TechnicalLog";
  static String projectStepComment = "ProjectStepComment";
  static String projectProcessNext = "ProjectProcess/next";
  static String projectProcessStart = "WorkFlow/Run";
  static const latestRequest = "ProjectProcess/Active";

  // Jobs APIs ====================
  static const jobs = "chances";

  // PMS APIs ====================
  static const appraisalReviewCycles = "appraisal/review-cycles";
  static const users = "users";
  static const seniorityLevels = "seniority-levels";
  static const allTeams = "all-teams";
  static String userReviewCycles(int userId) =>
      'users/$userId/review-cycles';
  static String userLastReviewCycleReport(int userId) =>
      'users/$userId/last-review-cycle-report';
  static String reviewCycleSummary(int cycleId) =>
      'appraisal/review-cycles/$cycleId/summary';
  static String reviewCycleRevieweeStatus(int cycleId) =>
      'appraisal/review-cycles/$cycleId/reviewee-status';

  // Talent Pool APIs ====================
  static const talents = "candidates";
  static const exportZipFile = "candidates/export-resumes";
  static const exportExcelFile = "candidates/export-resumes-excel";
  static const assignCandidatesToJobs = "candidates/bulk-assign-to-job";
  static String candidateDetails(int id) => "candidates/$id";

  // Filters ===================================
  static const tags = "tags/get-all";
  static const sortingList = "candidates/sorting-list";
}
