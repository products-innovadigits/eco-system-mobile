import 'package:core_system/core/utility/export.dart';

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
      image: Assets.images.homeHeaderBg.path,
    ),
    IntroItem(
      title: "مشاريع سكنية",
      subTitle: "اجعل حلمك بالتملك العقاري حقيقة \nداخل تطبيقنا",
      image: Assets.images.newHomeHeaderBg.path,
    ),
    IntroItem(
      title: "مشاريع سكنية",
      subTitle: "اجعل حلمك بالتملك العقاري حقيقة \nداخل تطبيقنا",
      image: Assets.images.prfileHeaderBg.path,
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              50.sh,
              SizedBox(
                height: context.h / 1.9,
                width: context.w,
                child: PageView.builder(
                  controller: controller,
                  itemCount: introItems.length,
                  onPageChanged: (value) {
                    selectPage = value;
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.teal,
                      child: Images(image: introItems[index].image),
                    );
                  },
                ),
              ),
              40.sh,
              Text(
                introItems[selectPage].title,
                style: context.textTheme.titleLarge,
              ),
              SizedBox(height: 8.h),
              Text(
                introItems[selectPage].subTitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.color.outlineVariant,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    introItems.length,
                        (index) =>
                        Container(
                          margin: EdgeInsetsDirectional.only(end: 5.w),
                          height: 4,
                          width: selectPage == index ? 32 : 8,
                          decoration: BoxDecoration(
                            color: selectPage == index
                                ? context.color.primary
                                : context.color.outlineVariant,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                  ),
                ),
              ),
              selectPage != introItems.length - 1
                  ? GestureDetector(
                onTap: () {
                  if (selectPage == introItems.length - 1) {
                    CustomNavigator.push(Routes.MAIN_PAGE);
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
                              end:
                              (selectPage + 1) /
                                  introItems.length *
                                  1,
                            ),
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
                                color:
                                context.theme.scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : CustomBtn(
                text: allTranslations.text(LocaleKeys.login),
                onPressed: () {
                  return SharedHelper.sharedHelper?.writeData(
                    CachingKey.SKIP_BOARDING,
                    true,
                  ).then((v) {
                    CustomNavigator.push(Routes.LOGIN, clean: true);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IntroItem {
  final String title;
  final String subTitle;
  final String image;

  IntroItem({required this.title, required this.subTitle, required this.image});
}
