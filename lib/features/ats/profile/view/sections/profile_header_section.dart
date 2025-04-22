import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/profile/view/widgets/profile_custom_appbar_widget.dart';
import 'package:eco_system/features/ats/profile/view/widgets/profile_data_container_widget.dart';
import 'package:eco_system/features/ats/profile/view/widgets/profile_user_data_widget.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: context.w,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Assets.images.prfileHeaderBg.path),
            fit: BoxFit.fill),
      ),
      child: SafeArea(
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileCustomAppbarWidget(title: 'قائد فريق تصميم المنتجات'),
              16.sh,
              ProfileUserDataWidget(),
              10.sh,
              Row(
                spacing: 8.w,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ProfileDataContainerWidget(
                      title: 'مرحلة المقابلة الهاتفية',
                      icon: Assets.svgs.layers.path),
                  ProfileDataContainerWidget(
                      title: '010908888', icon: Assets.svgs.call.path),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
