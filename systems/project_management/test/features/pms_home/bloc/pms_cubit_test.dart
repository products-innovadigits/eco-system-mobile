import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/pms_home/bloc/pms_cubit.dart';
import 'package:project_management/features/pms_home/bloc/pms_state.dart';

void main() {
  group('PmsCubit', () {
    late PmsCubit cubit;

    setUp(() {
      cubit = PmsCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is PmsInitial', () {
      expect(cubit.state, const PmsInitial());
    });
  });
}
