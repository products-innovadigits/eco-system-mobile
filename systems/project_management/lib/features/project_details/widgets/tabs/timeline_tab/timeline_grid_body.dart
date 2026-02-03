import 'package:project_management/core/utility/pms_exports.dart';

/// Grid body (rows × dynamic weeks). Optionally builds custom cells via cellBuilder.
class TimelineGridBody extends StatelessWidget {
  final int rows;
  final double width, monthWidth, weekWidth, rowHeight;
  final int monthCount;

  const TimelineGridBody({
    super.key,
    required this.rows,
    required this.width,
    required this.monthWidth,
    required this.weekWidth,
    required this.rowHeight,
    required this.monthCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(rows, (r) {
        return SizedBox(
          width: width,
          height: rowHeight,
          child: Row(
            children: List.generate(monthCount, (m) {
              return SizedBox(
                width: monthWidth,
                height: rowHeight,
                child: Row(
                  children: List.generate(4, (w) {
                    return SizedBox(
                      width: weekWidth,
                      height: rowHeight,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: LightColor.timelineBorder),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
