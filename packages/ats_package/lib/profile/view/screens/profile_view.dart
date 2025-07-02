import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class ProfileView extends StatelessWidget {
  final bool isTalent;
  final int candidateId;

  const ProfileView(
      {super.key, this.isTalent = false, required this.candidateId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(Click(arguments: candidateId)),
      child: Scaffold(
        body: Column(
          children: [
            ProfileHeaderSection(isTalent: isTalent),
            ProfileBodySection(isTalent: isTalent),
          ],
        ),
      ),
    );
  }
}
