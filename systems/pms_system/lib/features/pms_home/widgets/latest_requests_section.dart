import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/latest_request/bloc/latest_request/latest_request_state.dart';

import '../../latest_request/bloc/latest_request/latest_request_cubit.dart';

class LatestRequestsSection extends StatelessWidget {
  const LatestRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LatestRequestCubit()..getLatestRequest(),
      child: BlocBuilder<LatestRequestCubit, LatestRequestState>(
        builder: (context, state) {
          return switch (state) {
            // Loading first page
            LatestRequestLoading() => const CustomShimmerContainer(
              padding: EdgeInsets.zero,
              height: 300,
            ),

            // Handle loaded state with data models
            LatestRequestLoaded(:final requests) => MainCardWidget(
              title: allTranslations.text(LocaleKeys.latest_requests),
              moreBtnTxt: allTranslations.text(LocaleKeys.view_more),
              onViewMoreTap: () {
                CustomNavigator.push(Routes.LATEST_REQUEST);
              },
              child: Column(
                children: List.generate(
                  requests.length > 3 ? 3 : requests.length,
                  (i) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: RequestCardWidget(requestItem: requests[i]),
                    );
                  },
                ),
              ),
            ),

            // Empty
            LatestRequestEmpty() => _HandleEmptyList(),

            // Error or fallback
            _ => ErrorContainer(),
          };
        },
      ),
    );
  }
}

class _HandleEmptyList extends StatelessWidget {
  const _HandleEmptyList();

  @override
  Widget build(BuildContext context) {
    return MainCardWidget(
      title: allTranslations.text(LocaleKeys.latest_requests),
      moreBtnTxt: allTranslations.text(LocaleKeys.view_more),
      onViewMoreTap: () {},
      child: Center(
        child: Text(allTranslations.text(LocaleKeys.there_is_no_data)),
      ),
    );
  }
}
