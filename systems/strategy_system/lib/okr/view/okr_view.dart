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
            final OkrBloc bloc = context.read<OkrBloc>();
            if (state is Loading || state is Start) {
              return ListAnimator(
                customPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                data: List.generate(
                  10,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomShimmerContainer(
                      height: 100.h,
                      width: context.w,
                    ),
                  ),
                ),
              );
            }
            if (state is Done) {
              final OkrVisionDataModel okrVisionData =
                  state.data as OkrVisionDataModel;
              return ListAnimator(
                customPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                data: [
                  /// Vision
                  OkrVisionSection(visionTitle: okrVisionData.title ?? ''),
                  16.sh,
                  /// Organizational Objectives Section
                  OkrOrganizationalObjectivesSection(
                    objectivesList: [
                      OkrObjectivesModel(
                        title: 'تميز تجربة العملاء',
                        keyResults: [
                          IndicatorModel(
                            title: 'مركز اتصال وخدمة موحدة ',
                            status: 'متقدم',
                            percentage: '70'
                          ),
                          IndicatorModel(
                            title: 'رفع مؤشر رضا المستفيد الي 90% ',
                            status: 'مكتمل',
                            percentage: '100'
                          ),
                          IndicatorModel(
                            title: 'اتاحة الوصول لذوي الاعاقة ',
                            status: 'متأخر',
                            percentage: '40'
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
                            percentage: '85'
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
                            percentage: '100'
                          ),
                          IndicatorModel(
                            title: 'تحسين جودة المحتوي الرقمي',
                            status: 'متأخر',
                            percentage: '30'
                          ),
                        ],
                        id: 3,
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return EmptyContainer(
                txt: allTranslations.text(LocaleKeys.something_went_wrong),
                img: Assets.svgs.error.path,
              );
            }
          },
        ),
      ),
    );
  }
}
