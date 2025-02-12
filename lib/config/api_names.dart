abstract class ApiNames {
  static const login = "Auth/Login";

  static const objectActivePercentage = "Dashboard/ObjectActivePersantge";
  static const objectActiveCategorized = "ObjectActive/Categorized";

  static const objectives = "ObjectActive";
  static objectiveDetails(id) => "ObjectActive/$id";
  static objectiveIndicators(id) => "ObjectActive/indicators/$id";
  static objectiveInitiatives(id) => "ObjectActive/initiatives/$id";
  static objectiveChartData(id) => "ObjectActive/chart/$id";
}
