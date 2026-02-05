import 'package:core_system/core/config/api_names.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/features/workflow_process_details/model/document_comments_model.dart';
import 'package:project_management/features/workflow_process_details/model/process_details_model.dart';
import 'package:project_management/features/workflow_process_details/data/repositories/process_details_repo_impl.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late ProcessDetailsRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = ProcessDetailsRepoImpl(network: mockNetwork);
  });

  group('ProcessDetailsRepoImpl', () {
    group('getGroupSteps', () {
      test(
        'returns GroupStepsModel on success with correct endpoint and method',
        () async {
          final expectedModel = GroupStepsModel(succeeded: true);

          when(
            () => mockNetwork.requestOrThrow(
              any(),
              body: any(named: 'body'),
              baseUrl: any(named: 'baseUrl'),
              systemTypeEnum: any(named: 'systemTypeEnum'),
              model: any(named: 'model'),
              query: any(named: 'query'),
              header: any(named: 'header'),
              method: any(named: 'method'),
            ),
          ).thenAnswer((_) async => expectedModel);

          final result = await repo.getGroupSteps(processId: 1, projectId: 1);

          expect(result, isA<GroupStepsModel>());
          expect(result.succeeded, true);
          verify(
            () => mockNetwork.requestOrThrow(
              ApiNames.workflowGroupSteps,
              query: any(named: 'query'),
              method: ServerMethods.GET,
              model: any(named: 'model'),
            ),
          ).called(1);
        },
      );

      test('throws NetworkException on error', () async {
        when(
          () => mockNetwork.requestOrThrow(
            any(),
            body: any(named: 'body'),
            baseUrl: any(named: 'baseUrl'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
            query: any(named: 'query'),
            header: any(named: 'header'),
            method: any(named: 'method'),
          ),
        ).thenThrow(NetworkException('Network error'));

        expect(
          () => repo.getGroupSteps(processId: 1, projectId: 1),
          throwsA(isA<NetworkException>()),
        );
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.workflowGroupSteps,
            query: any(named: 'query'),
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });

    group('getDocComments', () {
      test(
        'returns DocumentCommentsModel on success with correct endpoint and method',
        () async {
          final expectedModel = DocumentCommentsModel(succeeded: true);

          when(
            () => mockNetwork.requestOrThrow(
              any(),
              body: any(named: 'body'),
              baseUrl: any(named: 'baseUrl'),
              systemTypeEnum: any(named: 'systemTypeEnum'),
              model: any(named: 'model'),
              query: any(named: 'query'),
              header: any(named: 'header'),
              method: any(named: 'method'),
            ),
          ).thenAnswer((_) async => expectedModel);

          final result = await repo.getDocComments(documentId: 1);

          expect(result, isA<DocumentCommentsModel>());
          expect(result.succeeded, true);
          verify(
            () => mockNetwork.requestOrThrow(
              ApiNames.documentComment,
              query: any(named: 'query'),
              method: ServerMethods.GET,
              model: any(named: 'model'),
            ),
          ).called(1);
        },
      );

      test('throws NetworkException on error', () async {
        when(
          () => mockNetwork.requestOrThrow(
            any(),
            body: any(named: 'body'),
            baseUrl: any(named: 'baseUrl'),
            systemTypeEnum: any(named: 'systemTypeEnum'),
            model: any(named: 'model'),
            query: any(named: 'query'),
            header: any(named: 'header'),
            method: any(named: 'method'),
          ),
        ).thenThrow(NetworkException('Network error'));

        expect(
          () => repo.getDocComments(documentId: 1),
          throwsA(isA<NetworkException>()),
        );
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.documentComment,
            query: any(named: 'query'),
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });
  });
}
