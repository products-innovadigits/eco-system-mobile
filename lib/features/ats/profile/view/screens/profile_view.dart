import 'package:eco_system/utility/export.dart';

class ProfileView extends StatelessWidget {
  final bool isCandidate;

  const ProfileView({super.key, this.isCandidate = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
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
