import 'package:pms_system/shared/pms_exports.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 4,
      itemBuilder: (context, index) => _HistoryTimelineCard(
        processGroup: "Application Review",
        stageName: "طلب نموذج تغيير",
        employee: "سعد ضرغام",
        time: "10:00 AM",
        commenter: "محمود",
        comment: "التاكد من التوافق مع معايير مكتب ادارة المشاريع",
        hasAttachments: true,
        hasFields: true,
        date: "17",
        month: "ابريل",
      ),
      separatorBuilder: (context, index) => _TimelineConnector(),
    );
  }
}

class _HistoryTimelineCard extends StatelessWidget {
  final String processGroup;
  final String stageName;
  final String employee;
  final String time;
  final String commenter;
  final String comment;
  final bool hasAttachments;
  final bool hasFields;
  final String date;
  final String month;

  const _HistoryTimelineCard({
    required this.processGroup,
    required this.stageName,
    required this.employee,
    required this.time,
    required this.commenter,
    required this.comment,
    required this.hasAttachments,
    required this.hasFields,
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
                        label: "اسم المرحلة",
                        value: stageName,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _InfoSection(
                        label: "مجموعة العملية",
                        value: processGroup,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Employee info
                _InfoSection(label: "موظف", value: employee),
                SizedBox(height: 8.h),
                // Divider
                Container(height: 1, color: context.color.outline),
                SizedBox(height: 12.h),
                // Comment section
                _CommentSection(
                  time: time,
                  commenter: commenter,
                  comment: comment,
                ),
                SizedBox(height: 12.h),
                // Attachments and fields
                Row(
                  children: [
                    if (hasFields)
                      _AttachmentItem(
                        label: "الحقول المرتبطة",
                        icon: "reader", // TODO: Replace with actual icon
                      ),
                    SizedBox(width: 16.w),
                    if (hasAttachments) ...[
                      _AttachmentItem(
                        label: "المستندات المرتبطة",
                        icon: "reader", // TODO: Replace with actual icon
                      ),
                    ],
                  ],
                ),
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

class _CommentSection extends StatelessWidget {
  final String time;
  final String commenter;
  final String comment;

  const _CommentSection({
    required this.time,
    required this.commenter,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: [
                Images(image: Assets.svgs.comment.path),
                SizedBox(width: 4.w),
                Text(commenter, style: context.textTheme.bodySmall),
              ],
            ),
            Spacer(),
            Text(
              time,
              textDirection: TextDirection.ltr,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.color.secondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          '\"$comment\"',
          style: context.textTheme.bodySmall?.copyWith(fontSize: FontSizes.f10),
        ),
      ],
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  final String label;
  final String icon;

  const _AttachmentItem({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.color.surfaceContainer,
            border: Border.all(color: context.color.outline),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Images(image: Assets.svgs.reader.path),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.color.secondary,
          ),
        ),
      ],
    );
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
      margin: const EdgeInsetsDirectional.only(top: 12, bottom: 12, start: 42),
      height: 1,
      color: context.color.outline,
    );
  }
}
