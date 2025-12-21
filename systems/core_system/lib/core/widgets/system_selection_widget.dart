import 'package:core_system/core/utility/export.dart';

class SystemSelectionWidget extends StatelessWidget {
  final bool showAsButton;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  const SystemSelectionWidget({
    super.key,
    this.showAsButton = true,
    this.padding,
    this.fontSize,
  });

  void _showSystemSelectionBottomSheet(BuildContext context) {
    PopUpHelper.showBottomSheet(
      header: allTranslations.text(LocaleKeys.select_system),
      child: SystemSelectionBottomSheet(
        onSystemSelected: SystemHelper.handleSystemSelection,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!SystemHelper.shouldShowSystemWidget()) {
      return const SizedBox.shrink();
    }

    if (showAsButton) {
      return InkWell(
        onTap: () => _showSystemSelectionBottomSheet(context),
        child: Container(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: context.color.surfaceContainer,
            border: Border.all(color: context.color.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                SystemHelper.getSystemName(UserBloc.currentActiveSystem),
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize ?? 10,
                ),
              ),
              const SizedBox(width: 5),
              Images(image: Assets.svgs.arrowDown.path, width: 6, height: 6),
            ],
          ),
        ),
      );
    }

    return Text(
      SystemHelper.getSystemName(UserBloc.currentActiveSystem),
      style: context.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: fontSize ?? 10,
      ),
    );
  }
}

class SystemSelectionBottomSheet extends StatelessWidget {
  final Function(ActiveSystemEnum? systemEnum) onSystemSelected;

  const SystemSelectionBottomSheet({super.key, required this.onSystemSelected});

  @override
  Widget build(BuildContext context) {
    final systemOptions = SystemHelper.getAvailableSystems(
      UserBloc.currentActiveSystem,
    );

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 12.h),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final system = systemOptions[index];
        return InkWell(
          onTap: () {
            CustomNavigator.pop();
            onSystemSelected(system['enum'] as ActiveSystemEnum?);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: context.color.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    system['name'] as String,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.color.secondary,
                    ),
                  ),
                ),
                Images(
                  image: Assets.svgs.arrowLeft.path,
                  width: 16,
                  height: 16,
                  color: context.color.secondary,
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: systemOptions.length,
    );
  }
}
