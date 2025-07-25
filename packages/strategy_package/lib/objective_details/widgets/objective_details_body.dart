

import '../../shared/strategy_exports.dart';

class ObjectiveDetailsBody extends StatelessWidget {
  const ObjectiveDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ObjectiveDetailsBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          ObjectiveDetailsModel model =
          state.model as ObjectiveDetailsModel;
          return Column(
            children: [
              ObjectiveCardContent(objective: model , isDetails: true),
              SizedBox(height: 12.h),

              ///Objective Description
              ObjectiveDetailsLayout(
                title: allTranslations.text("description"),
                child: ObjectiveDetailsDescription(
                  description: model.description,
                  startDate: model.startDate,
                  endDate: model.endDate,
                ),
              ),
            ],
          );
        }
        if (state is Loading) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomShimmerContainer(
                  height: 130.h,
                  width: context.w,
                ),
              ),
              SizedBox(height: 12.h),
              Divider(color: context.color.outline, thickness: 1.0),
              CustomShimmerContainer(
                height: 130.h,
                width: context.w,
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
