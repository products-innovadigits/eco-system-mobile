import 'package:project_management/core/utility/project_management_exports.dart';

class AiAssistantView extends StatelessWidget {
  const AiAssistantView({super.key});

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
          statusBarIconBrightness:
              ThemeData.estimateBrightnessForColor(primary) == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
        ),
        title: Text(
          allTranslations.text(LocaleKeys.ai_assistant),
          style: context.textTheme.titleLarge?.copyWith(
            color: onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const SafeArea(child: AiAssistantBody()),
    );
  }
}
