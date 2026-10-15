import '../../shared/strategy_exports.dart';

// TODO: these perspectives and values are placeholders; no API feeds them yet.
class BscCardSection extends StatelessWidget {
  const BscCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StrategyFrameworkCard(
      title: allTranslations.text('bsc'),
      route: Routes.BSC,
      items: [
        ObjectiveKPIModel(
          kpiTitle: 'المنظور المالي',
          value: 80,
          color: '#175CD3',
        ),
        ObjectiveKPIModel(
          kpiTitle: 'المنظور العملاء',
          value: 70,
          color: '#079455',
        ),
        ObjectiveKPIModel(
          kpiTitle: 'المنظور العمليات الداخلية',
          value: 60,
          color: '#DC6803',
        ),
        ObjectiveKPIModel(
          kpiTitle: 'المنظور التعلم والنمو',
          value: 90,
          color: '#175CD3',
        ),
      ],
    );
  }
}
