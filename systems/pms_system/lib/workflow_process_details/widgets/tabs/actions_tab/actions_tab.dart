import 'package:pms_system/shared/pms_exports.dart';

class ActionsTab extends StatelessWidget {
  const ActionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Internal Comments Section
        _InternalCommentsSection(),

        // File Upload Section
        _FileUploadSection(),

        SizedBox(height: 16.h),

        // Action Buttons Section
        _ActionButtonsSection(),
      ],
    );
  }
}

class _InternalCommentsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: allTranslations.text(LocaleKeys.internal_comments),
          hint: allTranslations.text(LocaleKeys.enter_internal_comments),
          hintStyle: context.textTheme.bodySmall,
          maxLines: 3,
          minLines: 1,
        ),
      ],
    );
  }
}

class _FileUploadSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: allTranslations.text(LocaleKeys.upload_file),
          hint: allTranslations.text(LocaleKeys.upload_additional_file),
          hintStyle: context.textTheme.bodySmall,
          prefixWidget: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12, end: 4),
            child: Images(image: Assets.svgs.upload.path),
          ),
          isReadOnly: true,
          onTap: () {
            // TODO: Implement file upload functionality
          },
        ),
      ],
    );
  }
}

class _ActionButtonsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Save Button (Outlined)
        CustomBtn(
          text: allTranslations.text(LocaleKeys.save),
          color: Colors.transparent,
          textColor: context.color.primary,
          borderColor: context.color.primary,
          height: 34,
          fontSize: 12,
          borderRadius: 8,
          onPressed: () {
            // TODO: Implement save functionality
          },
        ),

        SizedBox(height: 16.h),

        // Primary Action Button
        SizedBox(
          width: double.infinity,
          child: CustomBtn(
            text: allTranslations.text(
              LocaleKeys.ensure_compliance_with_pmo_standards,
            ),
            color: context.color.primary,
            textColor: context.color.onPrimary,
            height: 34,
            fontSize: 12,
            borderRadius: 8,
            onPressed: () {
              // TODO: Implement primary action functionality
            },
          ),
        ),
      ],
    );
  }
}
