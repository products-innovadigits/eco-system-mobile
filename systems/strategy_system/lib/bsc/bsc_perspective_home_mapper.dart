import 'package:strategy_system/bsc/model/bsc_model.dart';
import 'package:strategy_system/objective_details/model/objective_indicator_model.dart';

/// Colors used on the home BSC card when the API does not send a color per perspective.
const _kBscHomePerspectivePalette = [
  '#175CD3',
  '#079455',
  '#DC6803',
  '#175CD3',
];

/// Used only when the API gives a perspective but no usable numeric/status/density signal.
const _kSimulatedPerspectiveDefaults = [72.0, 64.0, 58.0, 81.0];

/// Parses KPI/initiative percentage strings from the BSC API (e.g. `"72"`, `"72.5%"`).
double? parseIndicatorPercentage(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  final s = raw.trim().replaceAll('%', '').replaceAll(',', '.').trim();
  final v = double.tryParse(s);
  if (v == null) return null;
  if (v < 0) return 0;
  if (v > 100) return 100;
  return v;
}

double _clampPct(double v) => v.clamp(0.0, 100.0);

void _collectIndicators(ManzorModel m, void Function(IndicatorModel k) fn) {
  for (final o in m.objectives ?? []) {
    for (final k in o.kpIs ?? []) {
      fn(k);
    }
    for (final k in o.initiatives ?? []) {
      fn(k);
    }
  }
}

/// **Tier 1 — explicit progress:** average of all `kpIs` / `initiatives` `percentage`
/// fields under this perspective’s `objectActives`.
double? _averageKpiPercentageForManzor(ManzorModel m) {
  final values = <double>[];
  _collectIndicators(m, (k) {
    final p = parseIndicatorPercentage(k.percentage);
    if (p != null) values.add(p);
  });
  if (values.isEmpty) return null;
  return values.reduce((a, b) => a + b) / values.length;
}

/// **Tier 2 — status text:** maps common `status` strings to a 0–100 score, then averages
/// all KPIs/initiatives that have a non-empty status but no usable `percentage`.
double? _averageStatusScoreForManzor(ManzorModel m) {
  double? scoreFromStatus(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final t = s.toLowerCase().trim();
    if (t.contains('complete') ||
        t.contains('done') ||
        t.contains('closed') ||
        t.contains('مكتمل') ||
        t.contains('منجز')) {
      return 100;
    }
    if (t.contains('progress') ||
        t.contains('active') ||
        t.contains('جار') ||
        t.contains('قيد')) {
      return 55;
    }
    if (t.contains('hold') ||
        t.contains('delay') ||
        t.contains('risk') ||
        t.contains('متوقف') ||
        t.contains('تأخير')) {
      return 30;
    }
    if (t.contains('not') && t.contains('start')) return 8;
    if (t.contains('cancel')) return 0;
    return 45;
  }

  final scores = <double>[];
  _collectIndicators(m, (k) {
    if (parseIndicatorPercentage(k.percentage) != null) return;
    final sc = scoreFromStatus(k.status);
    if (sc != null) scores.add(sc);
  });
  if (scores.isEmpty) return null;
  return scores.reduce((a, b) => a + b) / scores.length;
}

/// **Tier 3 — activity in response (no % / status):** more objectives and more
/// KPI/initiative rows ⇒ slightly higher bar (proxy for “defined work”), capped at 90.
double? _densityScoreForManzor(ManzorModel m) {
  final objectives = m.objectives ?? [];
  if (objectives.isEmpty) return null;
  var indicatorRows = 0;
  for (final o in objectives) {
    indicatorRows += (o.kpIs?.length ?? 0) + (o.initiatives?.length ?? 0);
  }
  if (indicatorRows == 0) {
    final n = objectives.length;
    return _clampPct(38 + n * 7.5);
  }
  return _clampPct(32 + indicatorRows * 3.2 + objectives.length * 2.0);
}

/// Resolves one perspective’s % for the home card (see doc on [objectiveKpiModelsFromManzors]).
double resolvePerspectivePercentage(ManzorModel m, int perspectiveIndex) {
  final a = _averageKpiPercentageForManzor(m);
  if (a != null) return _clampPct(a);

  final b = _averageStatusScoreForManzor(m);
  if (b != null) return _clampPct(b);

  final c = _densityScoreForManzor(m);
  if (c != null) return _clampPct(c);

  return _kSimulatedPerspectiveDefaults[
      perspectiveIndex % _kSimulatedPerspectiveDefaults.length];
}

/// Builds home BSC card rows from [VisionDataModel.manzors].
///
/// **Per perspective, percentage is chosen in order:**
/// 1. **Average of `percentage`** on all nested `kpIs` and `initiatives` (same as BSC detail data).
/// 2. Else **average of inferred scores from `status`** (English/Arabic keywords → 0–100).
/// 3. Else **density heuristic** from the response: count of `objectActives` and total KPI/initiative
///    rows — higher counts ⇒ higher % (proxy only, not real completion).
/// 4. Else **fixed non-zero defaults** per row index (UI-only when the payload has no signal).
///
/// **Still not from API:** perspective row color — [_kBscHomePerspectivePalette].
List<ObjectiveKPIModel> objectiveKpiModelsFromManzors(List<ManzorModel>? manzors) {
  if (manzors == null || manzors.isEmpty) return [];
  return List.generate(manzors.length, (i) {
    final m = manzors[i];
    return ObjectiveKPIModel(
      kpiTitle: m.title ?? '',
      value: resolvePerspectivePercentage(m, i),
      color: _kBscHomePerspectivePalette[i % _kBscHomePerspectivePalette.length],
    );
  });
}

/// Placeholder rows for loading/error or empty `manzors` — matches previous static home card.
List<ObjectiveKPIModel> simulatedBscHomeCardPlaceholders() => [
      ObjectiveKPIModel(
        kpiTitle: 'المنظور المالي',
        color: '#175CD3',
        value: 80,
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
    ];
