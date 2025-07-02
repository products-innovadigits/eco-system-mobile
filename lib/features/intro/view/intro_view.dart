import 'package:core_package/core/utility/export.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  int selectPage = 0;
  PageController controller = PageController();
  List<IntroItem> introItems = [
    IntroItem(
      title: "أراضي ومخططات",
      subTitle: "استثمر في المستقبل وامتلك الأرض \nالتي تحلم بها",
      images: [
        "",
        "",
        "",
        "",
      ],
    ),
    IntroItem(
      title: "مشاريع سكنية",
      subTitle: "اجعل حلمك بالتملك العقاري حقيقة \nداخل تطبيقنا",
      images: [
        "",
        "",
        "",
        "",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(height: 71.h),
            SizedBox(
              height: context.h / 1.7,
              width: context.w,
              child: PageView.builder(
                controller: controller,
                itemCount: introItems.length,
                onPageChanged: (value) {
                  selectPage = value;
                  setState(() {});
                },
                itemBuilder: (context, index) {
                  return Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      introItems[index].images.length,
                      (index2) => AnimationConfiguration.staggeredGrid(
                        columnCount: 2,
                        position: index2,
                        duration: const Duration(milliseconds: 300),
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: Container(
                              transform: Matrix4.translationValues(
                                index2 == 0
                                    ? 50.w
                                    : index2 == 3
                                        ? -50.w
                                        : 0,
                                index2 == 2
                                    ? -10
                                    : index2 == 1
                                        ? 10
                                        : 0,
                                0,
                              ),
                              width: index2 == 0 || index2 == 3
                                  ? context.w / 1.8
                                  : context.w / 2.8,
                              height: index2 == 0 || index2 == 3
                                  ? 120
                                  : context.w / 1.7,
                              decoration: BoxDecoration(
                                color: context.theme.primaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                introItems.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: selectPage == index
                          ? context.theme.primaryColor
                          : context.theme.primaryColorDark,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              introItems[selectPage].title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              introItems[selectPage].subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.theme.primaryColorDark,
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                if (selectPage == introItems.length - 1) {
                  CustomNavigator.push(Routes.MAIN_PAGE,
                      arguments: MainPageArgs(
                          index: 3, systems: UserBloc.activeSystems));
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: Container(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                              begin: 0.0,
                              end: (selectPage + 1) / introItems.length * 1),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, value, _) =>
                              CircularProgressIndicator(
                            value: value,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward,
                              color: context.theme.scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IntroItem {
  final String title;
  final String subTitle;
  final List<String> images;

  IntroItem({
    required this.title,
    required this.subTitle,
    required this.images,
  });
}
