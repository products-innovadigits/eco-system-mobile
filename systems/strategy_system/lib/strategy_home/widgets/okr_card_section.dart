import '../../shared/strategy_exports.dart';

// TODO: these objectives and values are placeholders; no API feeds them yet.
class OkrCardSection extends StatelessWidget {
  const OkrCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StrategyFrameworkCard(
      title: allTranslations.text(LocaleKeys.okr),
      route: Routes.OKR,
      items: [
        ObjectiveKPIModel(
          kpiTitle: 'تميز تجربة العملاء',
          value: 80,
          color: '#175CD3',
        ),
        ObjectiveKPIModel(
          kpiTitle: 'تعزيز الابتكار ونمو القدرات البشرية',
          value: 70,
          color: '#079455',
        ),
        ObjectiveKPIModel(
          kpiTitle: 'رفع كفاءة العمليات والتميز التشغيلي ',
          value: 60,
          color: '#DC6803',
        ),
        ObjectiveKPIModel(
          kpiTitle: 'تعظيم القيمة المستفيدة',
          value: 90,
          color: '#175CD3',
        ),
      ],
    );
  }
}
