import '../../shared/strategy_exports.dart';

class ObjectiveKPIS extends StatelessWidget {
  const ObjectiveKPIS({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectiveKPISBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          List<ObjectiveKPIModel> list = state.list as List<ObjectiveKPIModel>;
          return ObjectiveDetailsLayout(
            title: allTranslations.text("kpis"),
            subTitle: "${list.length} ${allTranslations.text("scale")}",
            child: Column(
              children: List.generate(
                  list.length,
                  (i) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                list[i].kpiTitle ?? "",
                                style: context.textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: LinearProgressIndicator(
                                    value: (list[i].value ?? 0) / 100,
                                    minHeight: 6.h,
                                    color: context.color.secondary,
                                    backgroundColor: context.color.secondary.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "${list[i].value ?? ""}%",
                              style: context.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      )),
            ),
          );
        }
        if (state is Loading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: CustomShimmerContainer(
              height: 130.h,
              width: context.w,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
