import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/network/error/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/bloc/cycles_bloc.dart';
import 'package:pms_system/features/cycles/bloc/cycles_events.dart';
import 'package:pms_system/features/cycles/bloc/cycles_states.dart';
import 'package:pms_system/features/cycles/model/cycles_model.dart';

import '../../../core/mocks/fallbacks.dart';
import '../../../core/mocks/mock_repos.dart';

void main() {
  late MockCyclesRepo mockRepo;

  setUpAll(() {
    initMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockCyclesRepo();
  });

  group('CyclesBloc', () {
    group('LoadCycles', () {
      blocTest<CyclesBloc, CyclesState>(
        'emits [CyclesLoading, CyclesLoaded] when repo returns data',
        build: () {
          when(() => mockRepo.getCycles(any())).thenAnswer(
            (_) async => CyclesModel(
              succeeded: true,
              data: CyclesDataModel(
                items: [CycleItemModel(id: 1, title: 'Test Cycle')],
                currentPage: 1,
                totalPages: 1,
                totalCount: 1,
                pageSize: 10,
              ),
            ),
          );
          return CyclesBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(LoadCycles(searchEngine: SearchEngine())),
        expect: () => [isA<CyclesLoading>(), isA<CyclesLoaded>()],
        verify: (_) {
          verify(() => mockRepo.getCycles(any())).called(1);
        },
      );

      blocTest<CyclesBloc, CyclesState>(
        'emits [CyclesLoading, CyclesEmpty] when repo returns empty data',
        build: () {
          when(() => mockRepo.getCycles(any())).thenAnswer(
            (_) async => CyclesModel(
              succeeded: true,
              data: CyclesDataModel(items: []),
            ),
          );
          return CyclesBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(LoadCycles(searchEngine: SearchEngine())),
        expect: () => [isA<CyclesLoading>(), isA<CyclesEmpty>()],
      );

      blocTest<CyclesBloc, CyclesState>(
        'emits [CyclesLoading, CyclesFailure] on NetworkException',
        build: () {
          when(() => mockRepo.getCycles(any()))
              .thenThrow(NetworkException('Network error'));
          return CyclesBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(LoadCycles(searchEngine: SearchEngine())),
        expect: () => [isA<CyclesLoading>(), isA<CyclesFailure>()],
        verify: (_) {
          verify(() => mockRepo.getCycles(any())).called(1);
        },
      );

      blocTest<CyclesBloc, CyclesState>(
        'emits [CyclesLoading, CyclesFailure] on generic exception',
        build: () {
          when(() => mockRepo.getCycles(any()))
              .thenThrow(Exception('Something went wrong'));
          return CyclesBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(LoadCycles(searchEngine: SearchEngine())),
        expect: () => [isA<CyclesLoading>(), isA<CyclesFailure>()],
      );
    });

    group('SearchChanged', () {
      blocTest<CyclesBloc, CyclesState>(
        'triggers LoadCycles and emits states',
        build: () {
          when(() => mockRepo.getCycles(any())).thenAnswer(
            (_) async => CyclesModel(
              succeeded: true,
              data: CyclesDataModel(items: []),
            ),
          );
          return CyclesBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const SearchChanged('test')),
        expect: () => [isA<CyclesLoading>(), isA<CyclesEmpty>()],
        verify: (_) {
          verify(() => mockRepo.getCycles(any())).called(1);
        },
      );
    });

    group('RefreshCycles', () {
      blocTest<CyclesBloc, CyclesState>(
        'clears data and reloads',
        build: () {
          when(() => mockRepo.getCycles(any())).thenAnswer(
            (_) async => CyclesModel(
              succeeded: true,
              data: CyclesDataModel(
                items: [CycleItemModel(id: 1, title: 'Refreshed')],
                currentPage: 1,
                totalPages: 1,
                totalCount: 1,
                pageSize: 10,
              ),
            ),
          );
          return CyclesBloc(repo: mockRepo);
        },
        act: (bloc) => bloc.add(const RefreshCycles()),
        expect: () => [isA<CyclesLoading>(), isA<CyclesLoaded>()],
        verify: (_) {
          verify(() => mockRepo.getCycles(any())).called(1);
        },
      );
    });
  });
}
