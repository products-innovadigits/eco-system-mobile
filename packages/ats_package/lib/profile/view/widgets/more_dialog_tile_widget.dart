import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class MoreDialogTileWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const MoreDialogTileWidget(
      {super.key,
      required this.title,
      required this.iconPath,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w * 0.5,
      child: InkWell(
        onTap: () {
          onTap();
          Future.microtask(() {
            context.read<ProfileBloc>().add(ShowDialog(arguments: false));
          });
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Images(image: iconPath , color: context.color.secondary),
                  8.sw,
                  Text(allTranslations.text(title),
                      style: context.textTheme.bodySmall)
                ],
              ),
            ),
            Divider(color: context.color.outline, height: 2.h),
          ],
        ),
      ),
    );
  }
}
