import 'package:eco_system/features/reports/model/report_model.dart';
import 'package:eco_system/features/reports/widgets/report_card_content.dart';
import 'package:pms_package/shared/pms_exports.dart';

class ReportCardWidget extends StatelessWidget {
  const ReportCardWidget({super.key, required this.reportData});

  final ReportData reportData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(color: context.color.surfaceContainer),
        child: ReportCardContent(report: reportData),
      ),
    );
  }
}
