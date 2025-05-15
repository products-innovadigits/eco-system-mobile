import 'package:eco_system/utility/export.dart';

class AssignToJobList extends StatelessWidget {
  final Function(int) onSelectJob;
  final List<int> selectedJobsList;

  const AssignToJobList(
      {super.key, required this.onSelectJob, required this.selectedJobsList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.6,
      child: ListView.separated(
        itemBuilder: (context, index) => InkWell(
          onTap: () => onSelectJob(index),
          child: Container(
            width: context.w,
            decoration: BoxDecoration(
                color: Styles.WHITE_COLOR,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Styles.BORDER)),
            child: Column(
              children: [
                StatusWidget(),
                Padding(
                  padding:
                      EdgeInsetsDirectional.only(start: 12.w, bottom: 24.h),
                  child: Row(
                    children: [
                      CustomCheckBoxWidget(
                          onCheck: () => onSelectJob(index),
                          isChecked: selectedJobsList.contains(index)),
                      8.sw,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'قائد فريق  تصميم المنتجات',
                            style: AppTextStyles.w500
                                .copyWith(color: Styles.TEXT_COLOR),
                          ),
                          4.sh,
                          Text(
                            'دوام كامل . مصر . تصميم',
                            style: AppTextStyles.w400.copyWith(
                                color: Styles.SUB_TEXT_DARK_COLOR,
                                fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        separatorBuilder: (context, index) => 12.sh,
        itemCount: 12,
      ),
    );
  }
}
