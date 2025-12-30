import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/latest_request/bloc/filtration/latest_request_filtration_cubit.dart';
import 'package:pms_system/features/latest_request/bloc/filtration/latest_request_filtration_state.dart';
import 'package:pms_system/features/latest_request/bloc/latest_request/latest_request_cubit.dart';
import 'package:pms_system/features/latest_request/widgets/latest_request_filter/latest_request_filter_bottom_sheet_body.dart';
import 'package:pms_system/features/latest_request/widgets/latest_request_filter/latest_request_filter_buttons_section.dart';

class LatestRequestFilterBottomSheet extends StatelessWidget {
  const LatestRequestFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LatestRequestFiltrationCubit, LatestRequestFiltrationState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        final filterCubit = context.read<LatestRequestFiltrationCubit>();
        final latestRequestCubit = context.read<LatestRequestCubit>();
        return Stack(
          children: [
            state is LatestRequestFiltrationLoading
                ? const ShimmerCardsList(
                    itemCount: 4,
                    cardHeight: 50,
                    listPadding: 0,
                  )
                : const LatestRequestFilterBottomSheetBody(),
            if (state is LatestRequestFiltrationLoaded)
              LatestRequestFilterButtonsSection(
                onApplyFilters: () =>
                    filterCubit.applyFilters(latestRequestCubit: latestRequestCubit),
                onResetFilters: () =>
                    filterCubit.resetFilters(latestRequestCubit: latestRequestCubit),
                isFiltered: state.isFilterApplied,
              ),
          ],
        );
      },
    );
  }
}
