
import 'package:eco_system/features/reports/bloc/reports_bloc.dart';
import 'package:eco_system/features/reports/widgets/reports_filter.dart';
import 'package:pms_package/shared/pms_exports.dart';

class ReportsSearchBar extends StatefulWidget {
  const ReportsSearchBar({super.key});

  @override
  State<ReportsSearchBar> createState() => _ReportsSearchBarState();
}

class _ReportsSearchBarState extends State<ReportsSearchBar> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, AppState>(
      builder: (context, state) {
        return StreamBuilder(
          stream: context.read<ReportsBloc>().goingDownStream,
          builder: (context, snapshot) {
            return AnimatedCrossFade(
              crossFadeState: snapshot.data == true
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 400),
              firstChild: SizedBox(width: context.w),
              secondChild: Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 8.h,
                  bottom: 8.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: CustomTextField(
                        hint: allTranslations.text("search_hint"),
                        controller: context.read<ReportsBloc>().searchTEC,
                        prefixSvg: "search",
                        borderColor: context.color.outline,
                        addBorder: true,
                        onChanged: (v) {
                          if (timer != null) if (timer!.isActive)
                            timer!.cancel();
                          timer = Timer(
                            const Duration(milliseconds: 400),
                                () {
                              context
                                  .read<ReportsBloc>()
                                  .add(Click(arguments: SearchEngine()));
                            },
                          );
                        },
                        onSaved: (v) {
                          context
                              .read<ReportsBloc>()
                              .add(Click(arguments: SearchEngine()));
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                        flex: 3,
                        child: ReportsFilter(
                          initialSelection:
                          context.read<ReportsBloc>().filter.valueOrNull,
                          onSelect: (v) {
                            context.read<ReportsBloc>().updateFilter(v);
                            context
                                .read<ReportsBloc>()
                                .add(Click(arguments: SearchEngine()));
                          },
                        )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
