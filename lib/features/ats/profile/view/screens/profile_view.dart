import 'package:eco_system/features/ats/profile/view/sections/profile_body_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_header_section.dart';
import 'package:eco_system/utility/export.dart';

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
