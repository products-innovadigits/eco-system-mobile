import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/bloc/history_tab_bloc.dart';
import 'package:pms_system/workflow_process_details/model/history_model.dart';

class HistoryTab extends StatelessWidget {
  final int processId;
  final int projectId;

  const HistoryTab({
    super.key,
    required this.processId,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryTabBloc(),
      child: _HistoryTabContent(processId: processId, projectId: projectId),
    );
  }
}

class _HistoryTabContent extends StatefulWidget {
  final int processId;
  final int projectId;

  const _HistoryTabContent({required this.processId, required this.projectId});

  @override
  State<_HistoryTabContent> createState() => _HistoryTabContentState();
}

class _HistoryTabContentState extends State<_HistoryTabContent> {
  late HistoryTabBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<HistoryTabBloc>();

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(
        Click(
          arguments: {
            'processId': 146,
            // 'processId': widget.processId,
            'projectId': 51,
            // 'projectId': widget.projectId,
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryTabBloc, AppState>(
      builder: (context, state) {
        return switch (state) {
          // ── Loading ─────────────────────────
          Loading() ||
          Start() => ShimmerCardsList(itemCount: 3, cardHeight: 200),

          // ── Done ────────────────────────────
          Done(:final model) => _HistoryContent(
            historyModel: model as HistoryResponseModel,
          ),

          // ── Empty ───────────────────────────
          Empty() => const EmptyContainer(),

          // ── Error / fallback ────────────────
          _ => EmptyContainer(
            txt: allTranslations.text(LocaleKeys.something_went_wrong),
            img: Assets.svgs.error.path,
          ),
        };
      },
    );
  }
}

class _HistoryContent extends StatelessWidget {
  final HistoryResponseModel historyModel;

  const _HistoryContent({required this.historyModel});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: historyModel.data!.length,
      itemBuilder: (context, index) {
        final historyItem = historyModel.data![index];
        return _HistoryTimelineCard(
          processGroup: historyItem.stepGroup?.groupName ?? "مرحلة التحضير",
          stageName: historyItem.name ?? "إنشاء طلب المشروع",
          employee:
              historyItem.responsibleUser?.fullName ?? "سعد بن محمد الشهري",
          time: _formatTime(historyItem.lastChangeTime),
          commenter:
              historyItem.responsibleUser?.fullName ?? "سعد بن محمد الشهري",
          comments: historyItem.stepComments ?? [],
          attachments: historyItem.slicesData ?? [],
          date: _formatDate(historyItem.lastChangeTime, isDate: true),
          month: _formatDate(historyItem.lastChangeTime, isMonth: true),
        );
      },
      separatorBuilder: (context, index) => _TimelineConnector(),
    );
  }

  String _formatTime(String? lastChangeTime) {
    if (lastChangeTime == null) return "10:00 AM";
    try {
      final dateTime = DateTime.parse(lastChangeTime);
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return "$displayHour:$minute $period";
    } catch (e) {
      return "10:00 AM";
    }
  }

  String _formatDate(
    String? lastChangeTime, {
    bool isDate = false,
    bool isMonth = false,
  }) {
    if (lastChangeTime == null) return isDate ? "17" : "ابريل";
    try {
      final dateTime = DateTime.parse(lastChangeTime);
      if (isDate) {
        return dateTime.day.toString();
      } else if (isMonth) {
        const months = [
          "يناير",
          "فبراير",
          "مارس",
          "ابريل",
          "مايو",
          "يونيو",
          "يوليو",
          "أغسطس",
          "سبتمبر",
          "أكتوبر",
          "نوفمبر",
          "ديسمبر",
        ];
        return months[dateTime.month - 1];
      }
      return dateTime.day.toString();
    } catch (e) {
      return isDate ? "17" : "ابريل";
    }
  }
}

class _HistoryTimelineCard extends StatelessWidget {
  final String processGroup;
  final String stageName;
  final String employee;
  final String time;
  final String commenter;
  final List<StepCommentModel> comments;
  final List<AttachmentModel> attachments;
  final String date;
  final String month;

  const _HistoryTimelineCard({
    required this.processGroup,
    required this.stageName,
    required this.employee,
    required this.time,
    required this.commenter,
    required this.comments,
    required this.attachments,
    required this.date,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        _TimelineIndicator(date: date, month: month),
        SizedBox(width: 8.w),
        // Main content card
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: context.color.surfaceContainer,
              border: Border.all(color: context.color.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Process group and stage info
                Row(
                  children: [
                    Expanded(
                      child: _InfoSection(
                        label: allTranslations.text(
                          LocaleKeys.stage_name_label,
                        ),
                        value: stageName,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _InfoSection(
                        label: allTranslations.text(
                          LocaleKeys.process_group_label,
                        ),
                        value: processGroup,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Employee info
                _InfoSection(
                  label: allTranslations.text(LocaleKeys.employee_label),
                  value: employee,
                ),
                SizedBox(height: 8.h),
                // Divider
                Container(height: 1, color: context.color.outline),
                SizedBox(height: 12.h),
                // Comments section
                _CommentsSection(comments: comments),
                SizedBox(height: 12.h),
                // Attachments section
                _AttachmentsSection(attachments: attachments),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String label;
  final String value;

  const _InfoSection({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: context.color.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(75),
          ),
          child: Images(image: Assets.svgs.calendar.path, color: Colors.black),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: FontSizes.f10,
                  color: context.color.outlineVariant,
                ),
              ),
              Text(
                value,
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: FontSizes.f10,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentsSection extends StatelessWidget {
  final List<StepCommentModel> comments;

  const _CommentsSection({required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: context.color.surfaceContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: context.color.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: Text(
            allTranslations.text(LocaleKeys.no_comments_available),
            style: context.textTheme.labelSmall?.copyWith(
              color: context.color.outlineVariant,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...comments.map(
          (comment) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _CommentItem(comment: comment),
          ),
        ),
      ],
    );
  }
}

class _CommentItem extends StatelessWidget {
  final StepCommentModel comment;

  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.color.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Images(image: Assets.svgs.comment.path),
              SizedBox(width: 4.w),
              Text(
                comment.commenter?.fullName ??
                    allTranslations.text(LocaleKeys.unknown),
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                _formatCommentTime(comment.createdAt),
                textDirection: TextDirection.ltr,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.secondary,
                  fontSize: FontSizes.f10,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            comment.text ?? '',
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: FontSizes.f10,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCommentTime(String? createdAt) {
    if (createdAt == null) return "10:00 AM";
    try {
      final dateTime = DateTime.parse(createdAt);
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return "$displayHour:$minute $period";
    } catch (e) {
      return "10:00 AM";
    }
  }
}

class _AttachmentsSection extends StatelessWidget {
  final List<AttachmentModel> attachments;

  const _AttachmentsSection({required this.attachments});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: attachments
          .map((attachment) => _AttachmentItem(attachment: attachment))
          .toList(),
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  final AttachmentModel attachment;

  const _AttachmentItem({required this.attachment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getFileIcon(attachment.type),
            size: 16,
            color: context.color.secondary,
          ),
          SizedBox(width: 4.w),
          Text(
            attachment.name ??
                allTranslations.text(LocaleKeys.attachments_count),
            style: context.textTheme.bodySmall?.copyWith(
              color: context.color.secondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      default:
        return Icons.attach_file;
    }
  }
}

class _TimelineIndicator extends StatelessWidget {
  final String date;
  final String month;

  const _TimelineIndicator({required this.date, required this.month});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Month label
        Text(
          month,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.color.primary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        // Date badge
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: context.color.secondary,
            borderRadius: BorderRadius.circular(1000),
          ),
          child: Center(
            child: Text(
              date,
              style: context.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        // Timeline line
        Container(
          width: 4.w,
          height: 134.h,
          decoration: BoxDecoration(
            color: context.color.secondary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(2),
              bottomRight: Radius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 4, bottom: 14, start: 42),
      height: 1,
      color: context.color.outline,
    );
  }
}
