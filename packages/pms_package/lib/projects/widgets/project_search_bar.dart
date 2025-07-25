
import 'package:pms_package/shared/pms_exports.dart';

class ProjectsSearchBar extends StatefulWidget {
  const ProjectsSearchBar({super.key});

  @override
  State<ProjectsSearchBar> createState() => _ProjectsSearchBarState();
}

class _ProjectsSearchBarState extends State<ProjectsSearchBar> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsBloc, AppState>(
      builder: (context, state) {
        return StreamBuilder(
          stream: context.read<ProjectsBloc>().goingDownStream,
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
                        controller: context.read<ProjectsBloc>().searchTEC,
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
                                  .read<ProjectsBloc>()
                                  .add(Click(arguments: SearchEngine()));
                            },
                          );
                        },
                        onSaved: (v) {
                          context
                              .read<ProjectsBloc>()
                              .add(Click(arguments: SearchEngine()));
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                        flex: 3,
                        child: ProjectPriorityFilter(
                          initialSelection:
                              context.read<ProjectsBloc>().filter.valueOrNull,
                          onSelect: (v) {
                            context.read<ProjectsBloc>().updateFilter(v);
                            context
                                .read<ProjectsBloc>()
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
