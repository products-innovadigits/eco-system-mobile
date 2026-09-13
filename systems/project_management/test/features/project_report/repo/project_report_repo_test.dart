import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_network.dart';

void main() {
  setUpAll(() {
    initMocktailFallbacks();
  });

  late MockNetwork mockNetwork;
  late ProjectReportRepoImpl repo;

  setUp(() {
    mockNetwork = MockNetwork();
    repo = ProjectReportRepoImpl(network: mockNetwork);
  });

  group('ProjectReportRepoImpl', () {
    const testId = 7;

    group('getProjectReport', () {
      test('returns ProjectReportModel on success with correct endpoint and method', () async {
        final expectedModel = ProjectReportModel.fromJson({
          'succeeded': true,
          'data': {
            'details': {'projectName': 'Annual Tech Review'},
          },
        });

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

        final result = await repo.getProjectReport(testId);

        expect(result, isA<ProjectReportModel>());
        expect(result.succeeded, isTrue);
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectReport(testId),
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });

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
          () => repo.getProjectReport(testId),
          throwsA(isA<NetworkException>()),
        );
        verify(
          () => mockNetwork.requestOrThrow(
            ApiNames.projectReport(testId),
            method: ServerMethods.GET,
            model: any(named: 'model'),
          ),
        ).called(1);
      });
    });
  });
}
