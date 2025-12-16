import '../utility/export.dart';

class ErrorContainer extends StatelessWidget {
  const ErrorContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyContainer(
      txt: allTranslations.text(LocaleKeys.something_went_wrong),
      img: Assets.svgs.error.path,
    );
  }
}
