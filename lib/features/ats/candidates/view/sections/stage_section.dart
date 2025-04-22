import 'package:eco_system/features/ats/candidates/view/widgets/candidate_card_widget.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class StageSection extends StatelessWidget {
  final String stageName;

  const StageSection({super.key, required this.stageName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: Styles.PRIMARY_COLOR),
              SizedBox(width: 8.w),
              Text(
                stageName,
                style: AppTextStyles.w500
                    .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR),
              ),
              4.sw,
              Text('(2)',
                  style: AppTextStyles.w500
                      .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 12)),
            ],
          ),
          16.sh,
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return CandidateCardWidget();
            },
            separatorBuilder: (context, index) => 16.sh,
          ),
        ],
      ),
    );
  }
}
