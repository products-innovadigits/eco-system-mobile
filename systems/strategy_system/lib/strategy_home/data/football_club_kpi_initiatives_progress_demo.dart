import 'package:strategy_system/strategy_home/model/kpis_initiatives_progress_model.dart';

/// Stacked KPI / initiative demo for the football-club target client.
///
/// Titles align with [okrFootballClubDemoObjectives] and strategic-axes demo
/// objectives; [kpisValue] + [initiativesValue] equals [objectiveValue] per bar.
List<KpisInitiativesProgressModel> footballClubKpiInitiativesProgressDemo() => [
      KpisInitiativesProgressModel(
        objective: 'تعزيز الأداء الرياضي للفريق الأول',
        kpisValue: 42,
        initiativesValue: 24,
        objectiveValue: 66,
      ),
      KpisInitiativesProgressModel(
        objective: 'تطوير الأكاديمية ومسار المواهب',
        kpisValue: 52,
        initiativesValue: 32,
        objectiveValue: 84,
      ),
      KpisInitiativesProgressModel(
        objective: 'تجربة مشجع عالية الجودة',
        kpisValue: 38,
        initiativesValue: 25,
        objectiveValue: 63,
      ),
      KpisInitiativesProgressModel(
        objective: 'خفض غياب اللاعبين للإصابة',
        kpisValue: 28,
        initiativesValue: 20,
        objectiveValue: 48,
      ),
      KpisInitiativesProgressModel(
        objective: 'توسيع برامج اكتشاف المواهب',
        kpisValue: 44,
        initiativesValue: 24,
        objectiveValue: 68,
      ),
      KpisInitiativesProgressModel(
        objective: 'تحسين رحلة التذاكر والخدمات الرقمية',
        kpisValue: 36,
        initiativesValue: 26,
        objectiveValue: 62,
      ),
      KpisInitiativesProgressModel(
        objective: 'زيادة التفاعل الرقمي مع الجمهور',
        kpisValue: 24,
        initiativesValue: 17,
        objectiveValue: 41,
      ),
    ];
