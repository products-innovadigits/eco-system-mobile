import 'package:eco_system/utility/export.dart';

class ProfileView extends StatelessWidget {
  final bool isCandidate;
  final int candidateId;

  const ProfileView(
      {super.key, this.isCandidate = false, required this.candidateId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(Click(arguments: candidateId)),
      child: Scaffold(
        body: Column(
          children: [
            ProfileHeaderSection(isCandidate: isCandidate),
            ProfileBodySection(isCandidate: isCandidate),
          ],
        ),
      ),
    );
  }
}
