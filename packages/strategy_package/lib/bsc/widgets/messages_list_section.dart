import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';

class MessagesListSection extends StatefulWidget {
  final List<MissionModel> messages;

  const MessagesListSection({super.key, required this.messages});

  @override
  State<MessagesListSection> createState() => _MessagesListSectionState();
}

class _MessagesListSectionState extends State<MessagesListSection> {
  bool _isMessagesExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.messages.isNotEmpty ? widget.messages[0].name! : '',
            style: context.textTheme.bodySmall,
          ),
          secondChild: Column(
            children: List.generate(widget.messages.length, (index) {
              final MissionModel message = widget.messages[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 6.w, color: context.color.primary),
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
          crossFadeState: _isMessagesExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 400),
        ),
        if (widget.messages.length > 1)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isMessagesExpanded = !_isMessagesExpanded;
                });
              },
              child: Text(
                _isMessagesExpanded
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
  }
}
