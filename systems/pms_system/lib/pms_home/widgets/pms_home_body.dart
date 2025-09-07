import 'package:pms_system/pms_home/model/timeline_project_model.dart';
import 'package:pms_system/pms_home/widgets/timeline/timeline_widget.dart';

import '../../shared/pms_exports.dart';

class PmsHomeBody extends StatelessWidget {
  const PmsHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PmsBloc(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            spacing: 16.h,
            children: [
              const SizedBox(height: 80),
              ProjectManagementSection(isPmsHome: true),
              const LatestRequestsSection(),
              ProjectTimeline(
                // canvasHeight: 400,
                // keep true since your layout is RTL
                timelineProjects: [
                  ProjectItem(
                    startMonth: 1,
                    startWeek: 2,
                    endMonth: 2,
                    endWeek: 3,
                    name:
                    'النشاط الرئيسي 01 – رفع جاهزية مركز عمليات الأمن السيبراني',
                    subProjects: [
                      ProjectItem(
                        startMonth: 1,
                        startWeek: 2,
                        endMonth: 2,
                        endWeek: 3,
                        name: 'SA-104 اختبار منصة',
                      ),
                      // ProjectItem(
                      //   startMonth: 1,
                      //   startWeek: 2,
                      //   endMonth: 2,
                      //   endWeek: 3,
                      //   name: 'SA-104 اختبار منصة',
                      // ),
                    ],
                  ),
                  ProjectItem(
                    startMonth: 1,
                    startWeek: 1,
                    endMonth: 2,
                    endWeek: 2,
                    name:
                    'النشاط الرئيسي 01 – رفع جاهزية مركز عمليات الأمن السيبراني',
                    subProjects: [
                      ProjectItem(
                        startMonth: 1,
                        startWeek: 2,
                        endMonth: 2,
                        endWeek: 3,
                        name: 'SA-104 اختبار منصة',
                      ),
                      ProjectItem(
                        startMonth: 1,
                        startWeek: 2,
                        endMonth: 2,
                        endWeek: 3,
                        name: 'SA-104 اختبار منصة',
                      ),
                      ProjectItem(
                        startMonth: 1,
                        startWeek: 2,
                        endMonth: 2,
                        endWeek: 3,
                        name: 'SA-104 اختبار منصة',
                      ),
                      ProjectItem(
                        startMonth: 1,
                        startWeek: 2,
                        endMonth: 2,
                        endWeek: 3,
                        name: 'SA-104 اختبار منصة',
                      ),
                    ],
                  ),
                  ProjectItem(
                    startMonth: 1,
                    startWeek: 3,
                    endMonth: 3,
                    endWeek: 1,
                    name: 'النشاط الرئيسى 01 – رفع جاهزية مركز عمليات الأمن ',
                  ),
                  ProjectItem(
                    startMonth: 1,
                    startWeek: 3,
                    endMonth: 3,
                    endWeek: 1,
                    name: 'النشاط الرئيسى 01 – رفع جاهزية مركز عمليات الأمن ',
                  ),
                  ProjectItem(
                    startMonth: 3,
                    startWeek: 1,
                    endMonth: 3,
                    endWeek: 4,
                    name: 'النشاط الرئيسى 01 – رفع جاهزية مركز عمليات الأمن ',
                  ),
                  ProjectItem(
                    startMonth: 4,
                    startWeek: 1,
                    endMonth: 5,
                    endWeek: 2,
                    name: 'النشاط الرئيسى 02 – رفع جاهزية مركز عمليات الأمن ',
                  ),
                  ProjectItem(
                    startMonth: 4,
                    startWeek: 1,
                    endMonth: 5,
                    endWeek: 2,
                    name: 'النشاط الرئيسى 02 – رفع جاهزية مركز عمليات الأمن ',
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
