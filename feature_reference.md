# FEATURE_REFERENCE_FULL.md — Unified Feature Reference
_Last updated: 2025-08-25_

This file is the **single source of truth** for generating **new features** in this project.  
Mention only this file in your prompt, and the agent should generate the full feature (Model, Repo, Bloc, View) consistently.

---

## 1) Feature Definition (What to include)
Each new feature must include:
- **Purpose & Success Criteria**
- **Domain models** (with `fromJson`, `toJson`, and `Mapper.fromJson()`)
- **Repository** (network calls, pagination, error mapping)
- **Bloc** (events/states, transitions, debounce)
- **View/UI** (loading/empty/error/success states, pagination, i18n)

---

## 2) Folder & Path Structure
```
/systems/{system_name}/lib/features/{feature_name}/
  ├─ model/        # Data classes & mappers
  ├─ repo/         # Repository interfaces & implementations
  ├─ bloc/         # Feature Bloc (events/states/logic)
  └─ view/         # Screens/widgets
```
- **Class names** → PascalCase (e.g., `JobsBloc`), **fields** → camelCase.  
- **Events** → intent-based (e.g., `LoadJobs`, `FilterChanged`, `CreateJob`).  
- **States** → `Start`, `Loading`, `Done`, `Error` (+ custom data).  

---

## 3) Domain Models
- Must extend the base mapping pattern (e.g., `SingleMapper`).  
- Always implement: `fromJson(Map)`, `toJson()`, and `Mapper.fromJson()`.  
- Reuse canonical types from `DOMAIN_DICTIONARY` (e.g., `PaginationMeta`, `ApiError`).  

### Example (Dart)
```dart
class ExampleModel extends SingleMapper {
  final String id;          
  final String title;
  final DateTime createdAt; 

  ExampleModel({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory ExampleModel.fromJson(Map<String, dynamic> json) => ExampleModel(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'created_at': createdAt.toIso8601String(),
      };

  static Mapper<ExampleModel> get mapper =>
      Mapper.fromJson((json) => ExampleModel.fromJson(json));
}
```

---

## 4) Repository Rules
- One repository per feature.  
- Methods: `getList`, `getDetails`, `create`, `update`, `delete`.  
- Accept filters (status, title, department), `page`, `limit`.  
- Map all errors to `ApiError`. Never throw raw responses.  
- Return strongly typed models and `PaginationMeta` for lists.  

### Example (Dart)
```dart
abstract class ExampleRepo {
  Future<PagedResponse<ExampleModel>> getList({
    int page = 1,
    int limit = 20,
    String? status,
    String? title,
  });

  Future<ExampleModel> getDetails(String id);
  Future<ExampleModel> create(Map<String, dynamic> payload);
  Future<ExampleModel> update(String id, Map<String, dynamic> payload);
  Future<void> delete(String id);
}
```

---

## 5) Bloc Rules
- Events: intent-based (`LoadList`, `ApplyFilters`, `CreateItem`, `DeleteItem`).  
- States: `Start`, `Loading`, `Done(data)`, `Error(message)`.  
- Use debounce for search API calls (e.g., 300–500ms).  
- Repo = single IO source.  

### Example (Dart)
```dart
sealed class ExampleEvent {}
class LoadList extends ExampleEvent {
  final int page;
  final int limit;
  final String? status;
  final String? title;
  LoadList({this.page = 1, this.limit = 20, this.status, this.title});
}

sealed class ExampleState {}
class Start extends ExampleState {}
class Loading extends ExampleState {}
class Done extends ExampleState {
  final List<ExampleModel> items;
  final PaginationMeta meta;
  Done(this.items, this.meta);
}
class ErrorState extends ExampleState {
  final String message;
  ErrorState(this.message);
}

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  final ExampleRepo repo;
  ExampleBloc(this.repo) : super(Start()) {
    on<LoadList>(_onLoadList, transformer: _debounce());
  }

  EventTransformer<LoadList> _debounce() {
    return (events, mapper) =>
        events.debounceTime(Duration(milliseconds: 350)).switchMap(mapper);
  }

  Future<void> _onLoadList(LoadList e, Emitter<ExampleState> emit) async {
    emit(Loading());
    try {
      final res = await repo.getList(
        page: e.page,
        limit: e.limit,
        status: e.status,
        title: e.title,
      );
      emit(Done(res.data, res.meta));
    } catch (err) {
      emit(ErrorState(ApiError.from(err).message));
    }
  }
}
```

---

## 6) View Rules
- Stateless UI when possible; no heavy logic in `build()`.  
- Handle all states: loading / empty / error / success.  
- No crashes on “No Data”.  
- Extract all labels to i18n (no hard-coded strings).  

### Example (Dart/Flutter)
```dart
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExampleBloc, ExampleState>(
      builder: (context, state) {
        if (state is Loading) return const Center(child: CircularProgressIndicator());
        if (state is ErrorState) return Center(child: Text(state.message));
        if (state is Done) {
          if (state.items.isEmpty) return const Center(child: Text('No Data'));
          return ListView.separated(
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final item = state.items[i];
              return ListTile(
                title: Text(item.title),
                subtitle: Text(item.id),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
```

---

## 7) API Contracts (General)
- Auth: Bearer token.  
- Query params: `page`, `limit`, `status`, `title`, `department`.  
- Responses:
  - List: `{ data: T[], meta: { page, limit, total } }`  
  - Details: `{ data: T }`  
  - Error: `{ message, code?, details? }`  

---

## 8) Security & Access Control
- Validate inputs (client + server).  
- Do not expose raw server messages.  
- Enforce RBAC in UI and confirm at API level.  

---

## 9) Prompting Usage
When creating a new feature:
- Attach the design screenshot.  
- Mention **@docs/FEATURE_REFERENCE_FULL.md**.  
- Specify:
  - Feature name  
  - Target path (e.g., `systems/ats_system/lib/features/job_tags/`)  
- Ask: “Generate Model + Repo + Bloc + View” following this reference.  
- Expect a **diff plan** first, then full code.