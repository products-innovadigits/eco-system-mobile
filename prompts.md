# Nawah Cursor Prompts (Templates)

Use these prompts inside Cursor to generate or update features.
The `.cursorrules` file will ensure structure + best practices.

---

## 🚀 Create New Feature
```
Generate a new feature called `feature_name` following Nawah structure.

- Create bloc, model, repo, view, and widgets folder.
- Model must include fromJson, toJson, and Mapper fromJson().
- Bloc with FeatureNameEvent, FeatureNameState, and FeatureNameBloc.
- Repo with FeatureNameRepo class and example fetch method.
- View file named feature_name_view.dart connected with BlocProvider.
- Add at least 2 example widgets under widgets/ folder.
```

---

## 🔄 Update Existing Feature
```
Update `feature_name` feature:

- Add new widget `new_widget_name.dart` under widgets/
- Widget must be StatelessWidget, use const constructor, and follow Nawah rules.
- Update feature_name_view.dart to include this widget.
```

---

## ✨ Refactor Model
```
Refactor `feature_name_model.dart`:
- Ensure all fields are final and use null safety.
- Add copyWith() method.
- Keep fromJson, toJson, and Mapper fromJson consistent with Nawah rules.
```

---

## ⚡ Refactor Bloc
```
Refactor `feature_name_bloc.dart`:
- Ensure events and states follow naming convention (<Feature>Event, <Feature>State).
- Make states sealed classes if possible.
- Keep Bloc lean and logic-only (no UI).
```
