import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/project_report/bloc/project_report_cubit.dart';
import 'package:project_management/features/project_report/bloc/project_report_state.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_repos.dart';

void main() {
  late MockProjectReportRepo mockRepo;
  late ProjectReportCubit cubit;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProjectReportRepo();
    cubit = ProjectReportCubit(repo: mockRepo);
  });

  tearDown(() {
  });

  group('ProjectReportCubit', () {
    group('loadProjectReport', () {
      blocTest<ProjectReportCubit, ProjectReportState>(
        'emits [Loading, Loaded] when repo returns success response',
        build: () {
          when(() => mockRepo.getProjectReport(any())).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {'id': 1, 'title': 'Test Report'},
            ),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadProjectReport(1),
        expect: () => [
          const ProjectReportLoading(),
          isA<ProjectReportLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getProjectReport(1)).called(1);
        },
      );

      blocTest<ProjectReportCubit, ProjectReportState>(
        'emits [Loading, Failure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getProjectReport(any()),
          ).thenThrow(NetworkException('Network error'));
          return cubit;
        },
        act: (cubit) => cubit.loadProjectReport(1),
        expect: () => [
          const ProjectReportLoading(),
          isA<ProjectReportFailure>(),
        ],
      );
    });
  });
}
