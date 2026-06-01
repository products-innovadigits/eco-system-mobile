import 'package:project_management/core/utility/project_management_exports.dart';

class AiAssistantView extends StatefulWidget {
  const AiAssistantView({super.key});

  @override
  State<AiAssistantView> createState() => _AiAssistantViewState();
}

class _AiAssistantViewState extends State<AiAssistantView> {
  final GlobalKey<AiAssistantBodyState> _chatBodyKey =
      GlobalKey<AiAssistantBodyState>();

  @override
  Widget build(BuildContext context) {
    final primary = context.color.primary;
    final onPrimary = context.color.onPrimary;
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: primary,
        foregroundColor: onPrimary,
        iconTheme: IconThemeData(color: onPrimary),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        title: Text(
          allTranslations.text(LocaleKeys.ai_assistant),
          style: context.textTheme.titleLarge?.copyWith(
            color: onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            tooltip: allTranslations.text(LocaleKeys.ai_assistant_reset_context_next),
            onPressed: () =>
                _chatBodyKey.currentState?.queueResetContextForNextMessage(),
            icon: Icon(Icons.layers_clear_outlined, color: onPrimary),
          ),
          IconButton(
            tooltip: allTranslations.text(LocaleKeys.ai_assistant_new_chat),
            onPressed: () => _chatBodyKey.currentState?.startNewChat(),
            icon: Icon(Icons.chat_outlined, color: onPrimary),
          ),
        ],
      ),
      body: SafeArea(child: AiAssistantBody(key: _chatBodyKey)),
    );
  }
}
