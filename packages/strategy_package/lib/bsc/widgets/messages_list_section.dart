import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/bloc/bsc_bloc.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';

class MessagesListSection extends StatelessWidget {
  const MessagesListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BscBloc, AppState>(
      builder: (context, state) {
        final BscBloc bloc = context.read<BscBloc>();
        return Column(
          children: [
            AnimatedCrossFade(
              firstChild: Text(
                bloc.messages.isNotEmpty ? bloc.messages[0].name! : '',
                style: context.textTheme.bodySmall,
              ),
              secondChild: Column(
                children: List.generate(bloc.messages.length, (index) {
                  final MissionModel message = bloc.messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8.w,
                          color: context.color.primary,
                        ),
                        8.sw,
                        Expanded(
                          child: Text(
                            message.name ?? '',
                            style: context.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              crossFadeState: bloc.isMessagesExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 400),
            ),
            if (bloc.messages.length > 1)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: InkWell(
                  onTap: () {
                    bloc.add(ToggleMessages());
                  },
                  child: Text(
                    bloc.isMessagesExpanded
                        ? allTranslations.text(LocaleKeys.show_less)
                        : allTranslations.text(LocaleKeys.show_more),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.color.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
