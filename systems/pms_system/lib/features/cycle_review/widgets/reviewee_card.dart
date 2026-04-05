import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

class ReviewCard extends StatefulWidget {
  final CycleRevieweeModel review;
  final bool initiallyExpanded;

  /// When set (e.g. from [CycleRevieweesView]), shows "Download report" in the expanded section.
  final int? cycleId;

  const ReviewCard({
    super.key,
    required this.review,
    this.initiallyExpanded = false,
    this.cycleId,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    return Container(
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(14.r),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: context.color.primary,
                      shape: BoxShape.circle,
                    ),
                    child: CustomNetworkImage.circleNewWorkImage(
                      backGroundColor: context.color.primary,
                      image: review.imageUrl,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.name ?? '',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          review.jobTitle ?? '',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.color.outlineVariant,
                            fontSize: 11.spMin,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${review.completedReviews ?? 0}/${review.totalReviews ?? 0}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.color.outlineVariant,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _PercentageBadge(
                    percentage: review.overallPercentage?.toInt() ?? 0,
                  ),
                  SizedBox(width: 8.w),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 22.r,
                      color: context.color.outlineVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _ExpandedContent(
              reviewee: review,
              cycleId: widget.cycleId,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

class _PercentageBadge extends StatelessWidget {
  final int percentage;

  const _PercentageBadge({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: LightColor.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$percentage%',
        style: context.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 11.spMin,
        ),
      ),
    );
  }
}

class _ExpandedContent extends StatelessWidget {
  final CycleRevieweeModel reviewee;
  final int? cycleId;

  const _ExpandedContent({required this.reviewee, this.cycleId});

  @override
  Widget build(BuildContext context) {
    final reviews = reviewee.reviews ?? [];
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...reviews.map(
            (review) => Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: _ReviewTypeCard(review: review),
            ),
          ),
          if (cycleId != null &&
              reviewee.completedReviews == reviewee.totalReviews) ...[
            SizedBox(height: reviews.isEmpty ? 8.h : 14.h),
            CustomBtn(
              text: allTranslations.text(LocaleKeys.download_report),
              onPressed: () {
                // TODO: wire download when reviewee report endpoint is available
                // (cycleId: $cycleId, revieweeId: ${reviewee.id})
              },
              height: 40,
              fontSize: FontSizes.f14,
              color: context.color.surfaceContainer,
              textColor: context.color.secondary,
              borderColor: context.color.outline,
            ),
          ],
        ],
      ),
    );
  }
}

class _ReviewTypeCard extends StatelessWidget {
  final CycleReviewTypeModel review;

  const _ReviewTypeCard({required this.review});

  IconData _iconForType(String? type) {
    switch (type) {
      case 'Manager Review':
        return Icons.assignment_ind_outlined;
      case 'Direct Report':
        return Icons.people_outline;
      case 'Peer Review':
        return Icons.groups_outlined;
      default:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewers = review.reviewers ?? [];
    final hasProgress =
        review.completedCount != null && review.totalCount != null;
    final progressRatio = hasProgress && review.totalCount! > 0
        ? (review.completedCount! / review.totalCount!).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _iconForType(review.type),
                size: 18.r,
                color: context.color.outlineVariant,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  review.type ?? '',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: FontSizes.f12,
                  ),
                ),
              ),
              Text(
                '${review.percentage?.toInt() ?? 0}%',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ...reviewers.map(
            (reviewer) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: _ReviewerRow(reviewer: reviewer),
            ),
          ),
          if (hasProgress && review.totalCount! > 0) ...[
            SizedBox(height: 4.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: progressRatio,
                minHeight: 6.h,
                color: LightColor.secondary,
                backgroundColor: LightColor.secondary.withValues(alpha: 0.1),
              ),
            ),
            SizedBox(height: 4.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                '${(progressRatio * 100).toInt()}% (${review.completedCount}/${review.totalCount})',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.outlineVariant,
                  fontSize: FontSizes.f10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReviewerRow extends StatelessWidget {
  final CycleReviewerInfoModel reviewer;

  const _ReviewerRow({required this.reviewer});

  Color _statusColor(String? status) {
    switch (status) {
      case 'Completed':
        return LightColor.tertiary;
      case 'Not Started':
        return LightColor.grey;
      case 'Overdue':
        return LightColor.error;
      default:
        return LightColor.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(reviewer.status);
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: context.color.primary,
            shape: BoxShape.circle,
          ),
          child: CustomNetworkImage.circleNewWorkImage(
            backGroundColor: context.color.primary,
            image: reviewer.imageUrl,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(reviewer.name ?? '', style: context.textTheme.bodySmall),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            (reviewer.status ?? '').toUpperCase(),
            style: context.textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: 9.spMin,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
