import 'package:strategy_system/okr/bloc/okr_bloc.dart';
import 'package:strategy_system/okr/model/okr_model.dart';
import 'package:strategy_system/okr/widgets/okr_organizational_objectives_section.dart';
import 'package:strategy_system/okr/widgets/okr_vision_section.dart';

import '../../shared/strategy_exports.dart';

class OkrView extends StatelessWidget {
  const OkrView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OkrBloc()..add(Click()),
      child: Scaffold(
        appBar: CustomAppBar(title: allTranslations.text(LocaleKeys.okr)),
        body: BlocBuilder<OkrBloc, AppState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            return switch (state) {
              // ── Loading ───────────────────────────
              Loading() => const ShimmerCardsList(cardHeight: 100),

              // ── Done ───────────────────────────────────────
              Done(:final data) => _OkrBody(
                visionData: data as OkrVisionDataModel,
              ),

              // ── Empty ───────────────────────────────────────
              Empty() => EmptyContainer(),

              // ── Error / fallback ───────────────────────────
              _ => EmptyContainer(
                txt: allTranslations.text(LocaleKeys.something_went_wrong),
                img: Assets.svgs.error.path,
              ),
            };
          },
        ),
      ),
    );
  }
}

class _OkrBody extends StatelessWidget {
  final OkrVisionDataModel visionData;

  const _OkrBody({required this.visionData});

  @override
  Widget build(BuildContext context) {
    return ListAnimator(
      customPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      data: [
        /// Vision
        OkrVisionSection(visionTitle: visionData.title ?? ''),
        SizedBox(height: 16.h),

        /// Organizational Objectives Section (example hardcoded list here)
        OkrOrganizationalObjectivesSection(
          objectivesList: [
            OkrObjectivesModel(
              title: 'تميز تجربة العملاء',
              keyResults: [
                IndicatorModel(
                  title: 'مركز اتصال وخدمة موحدة ',
                  status: 'متقدم',
                  percentage: '70',
                ),
                IndicatorModel(
                  title: 'رفع مؤشر رضا المستفيد الي 90% ',
                  status: 'مكتمل',
                  percentage: '100',
                ),
                IndicatorModel(
                  title: 'اتاحة الوصول لذوي الاعاقة ',
                  status: 'متأخر',
                  percentage: '40',
                ),
              ],
              id: 1,
            ),
            OkrObjectivesModel(
              title: 'تعزيز الابتكار ونمو القدرات البشرية',
              keyResults: [
                IndicatorModel(
                  title: 'تقليص وقت انجاز الخدمة',
                  status: 'متقدم',
                  percentage: '85',
                ),
              ],
              id: 2,
            ),
            OkrObjectivesModel(
              title: 'تعظيم القيمة المستفيدة',
              keyResults: [
                IndicatorModel(
                  title: 'تعزيز تقافة الاهتمام بالمستفيد',
                  status: 'مكتمل',
                  percentage: '100',
                ),
                IndicatorModel(
                  title: 'تحسين جودة المحتوي الرقمي',
                  status: 'متأخر',
                  percentage: '30',
                ),
              ],
              id: 3,
            ),
          ],
        ),
      ],
    );
  }
}
