import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/project_management_home/bloc/project_management_home_cubit.dart';
import 'package:project_management/features/project_management_home/bloc/project_management_home_state.dart';

void main() {
  group('ProjectManagementHomeCubit', () {
    late ProjectManagementHomeCubit cubit;

    setUp(() {
      cubit = ProjectManagementHomeCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is ProjectManagementHomeInitial', () {
      expect(cubit.state, const ProjectManagementHomeInitial());
    });
  });
}
