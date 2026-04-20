import 'package:core_system/core/utility/export.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الحساب")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListAnimator(
          verticalOffset: 50.0,
          horizontalOffset: 0.0,
          data: [
            SizedBox(height: 96.h),
            Center(
              child: Hero(
                tag: "logo",
                child: Material(
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: context.color.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Styles.logo(height: 56, width: 56),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 26.h),
            const Center(
              child: Text(
                "قم بتسجيل الدخول",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                "قم بتسجيل الدخول لكي تتمكن من \nالإستفادة من كامل المميزات",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: context.color.primary.withValues(alpha: 0.5),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Hero(
              tag: "btn",
              child: CustomBtn(
                text: "تسجيل الدخول",
                onPressed: () {
                  CustomNavigator.push(Routes.LOGIN);
                },
              ),
            ),
            SizedBox(height: 24.h),
            CustomBtn(
              text: "إنشاء حساب",
              color: context.color.secondary,
              borderColor: context.theme.primaryColor,
              textColor: context.theme.primaryColor,
              onPressed: () {
                CustomNavigator.push(Routes.SIGNUP);
              },
            ),
          ],
        ),
      ),
    );
  }
}
