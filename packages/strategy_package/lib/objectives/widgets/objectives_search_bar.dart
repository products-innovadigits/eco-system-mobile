
import '../../shared/strategy_exports.dart';

class ObjectivesSearchBar extends StatefulWidget {
  const ObjectivesSearchBar({super.key});

  @override
  State<ObjectivesSearchBar> createState() => _ObjectivesSearchBarState();
}

class _ObjectivesSearchBarState extends State<ObjectivesSearchBar> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectivesBloc, AppState>(
      builder: (context, state) {
        return StreamBuilder(
          stream: context.read<ObjectivesBloc>().goingDownStream,
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
                  top: 16.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: CustomTextField(
                        hint: allTranslations.text("search_hint"),
                        hintColor: context.color.outlineVariant,
                        controller: context.read<ObjectivesBloc>().searchTEC,
                        prefixSvg: "search",
                        borderColor: context.color.outline,
                        addBorder: true,
                        onChanged: (v) {
                          if (timer != null) if (timer!.isActive) {
                            timer!.cancel();
                          }
                          timer = Timer(
                            const Duration(milliseconds: 400),
                            () {
                              context
                                  .read<ObjectivesBloc>()
                                  .add(Click(arguments: SearchEngine()));
                            },
                          );
                        },
                        onSaved: (v) {
                          context
                              .read<ObjectivesBloc>()
                              .add(Click(arguments: SearchEngine()));
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                        flex: 3,
                        child: StrategicAxisFilter(
                          initialSelection:
                              context.read<ObjectivesBloc>().filter.valueOrNull,
                          onSelect: (CustomFieldModel? v) {
                            context.read<ObjectivesBloc>().updateFilter(v);
                            context
                                .read<ObjectivesBloc>()
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
