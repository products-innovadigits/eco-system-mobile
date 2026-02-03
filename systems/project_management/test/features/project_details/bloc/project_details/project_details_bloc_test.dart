import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/project_details/bloc/project_details/project_details_bloc.dart';
import 'package:project_management/features/project_details/bloc/project_details/project_details_events.dart';
import 'package:project_management/features/project_details/bloc/project_details/project_details_state.dart';

import '../../../../core/mocks/fallbacks.dart';
import '../../../../core/mocks/mock_repos.dart';

void main() {
  late MockProjectDetailsRepo mockRepo;
  late ProjectDetailsBloc bloc;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockProjectDetailsRepo();
    bloc = ProjectDetailsBloc(repo: mockRepo);
  });

  tearDown(() {
  });

  group('ProjectDetailsBloc', () {
    group('LoadProjectDetails', () {
      blocTest<ProjectDetailsBloc, ProjectDetailsState>(
        'emits [ProjectDetailsLoading, ProjectDetailsLoaded] when repo returns success response',
        build: () {
          when(() => mockRepo.getProjectDetails(any())).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {
                'data': {'id': 1, 'title': 'Test Project'},
              },
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadProjectDetails(projectId: 1)),
        expect: () => [
          const ProjectDetailsLoading(),
          isA<ProjectDetailsLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepo.getProjectDetails(1)).called(1);
        },
      );

      blocTest<ProjectDetailsBloc, ProjectDetailsState>(
        'emits [ProjectDetailsLoading, ProjectDetailsFailure] when repo throws NetworkException',
        build: () {
          when(
            () => mockRepo.getProjectDetails(any()),
          ).thenThrow(NetworkException('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadProjectDetails(projectId: 1)),
        expect: () => [
          const ProjectDetailsLoading(),
          isA<ProjectDetailsFailure>(),
        ],
      );
    });
  });
}
