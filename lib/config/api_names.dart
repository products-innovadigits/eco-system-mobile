abstract class ApiNames {
  static const login = "Auth/Login";

  static const objectActivePercentage = "Dashboard/ObjectActivePersantge";
  static const objectActiveCategorized = "ObjectActive/Categorized";

  static const objectives = "ObjectActive";
  static const strategicAxis = "ObjectActive/GetStrategicAxis";
  static objectiveDetails(id) => "ObjectActive/$id";
  static const objectiveKPIS = "KPIS/GetKpiByObjectActive";
  static const objectiveInitiatives = "Initiatives/ByObjectActive";
  static objectiveChartData(id,time) => "ObjectActive/$id/Chart/$time";


  static const projects = "Project";
  static const projectPriorityLevels = "Project/PeriortyLevels";
  static projectDetails(id) => "Project/$id";
  
}
