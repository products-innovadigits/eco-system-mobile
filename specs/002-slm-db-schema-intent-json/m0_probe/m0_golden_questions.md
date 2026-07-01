# M0 Golden Questions (projects domain)

**Feature:** `002-slm-db-schema-intent-json` · 50 questions · AR / EN / mixed
**Use:** feed one question at a time through the on-device probe; compare the model's Intent JSON to the **Expected** columns; score per `m0_measurement_checklist.md`. These are also the inputs for `deterministic_grounding_spike_scope.md`.

## Schema reference (from the real export)
- **Projects** columns incl.: `Id, Name, NameEn, Description, StartDate, EndDate, Budget, ManagerId(FK→AspNetUsers), ImplementorDepartmentId(FK→DepartmentLookups), SectionDepartmentId(FK→DepartmentLookups), PeriortyLevelId(FK→PeriortyLevels), ProjectCategoryId(FK→ProjectCategories), LifeCycleId(FK→ProjectLifeCycleModels), RiskLevelId(FK→RiskLevels)`. **No status column.**
- Lookups: `RiskLevels.Name=["مخاطر عالية","مخاطر متوسطة","مخاطر منخفضة"]`, `PeriortyLevels.Name=["أولوية عالية","أولوية متوسطة","أولوية منخفضة"]`, `DepartmentLookups.Name=[…real values…]`, `ProjectCategories.Name`, `ProjectLifeCycleModels.Title`.
- Conventions: **delayed/overdue** = `Projects.EndDate < today`. **Manager names** are NOT enumerated (free text → match `AspNetUsers.FullName`; if unknown → clarify). **Department/category/lifecycle** values must be validated against their lookup; if the requested value isn't present → `needs_clarification` / `invalid value`.

## Legend
`intent` ∈ list/count/summarize/get_detail/compare/unknown · `filter` = `Table.Column op value` · `rel` = FK relationship(s) expected · `clarify?` = expected `needs_clarification` (Y/N) · `unsupported` where noted.

| ID | Lang | Category | Question | intent | root | target tables | filter (Table.Column op value) | rel | clarify? | notes |
|---|---|---|---|---|---|---|---|---|---|---|
| G01 | AR | risk | مشاريع عالية الخطورة | list | Projects | RiskLevels | RiskLevels.Name eq "مخاطر عالية" | Projects→RiskLevels | N | the known failure case (must NOT map to priority) |
| G02 | EN | risk | show high risk projects | list | Projects | RiskLevels | RiskLevels.Name eq "مخاطر عالية" | Projects→RiskLevels | N | |
| G03 | AR | risk | كم عدد المشاريع منخفضة المخاطر؟ | count | Projects | RiskLevels | RiskLevels.Name eq "مخاطر منخفضة" | Projects→RiskLevels | N | count |
| G04 | mixed | risk | list المشاريع متوسطة المخاطر | list | Projects | RiskLevels | RiskLevels.Name eq "مخاطر متوسطة" | Projects→RiskLevels | N | |
| G05 | AR | priority | المشاريع ذات الأولوية العالية | list | Projects | PeriortyLevels | PeriortyLevels.Name eq "أولوية عالية" | Projects→PeriortyLevels | N | contrast with risk |
| G06 | EN | priority | projects with low priority | list | Projects | PeriortyLevels | PeriortyLevels.Name eq "أولوية منخفضة" | Projects→PeriortyLevels | N | |
| G07 | AR | risk-vs-priority | قارن المشاريع عالية الخطورة بالمشاريع عالية الأولوية | compare | Projects | RiskLevels, PeriortyLevels | RiskLevels.Name eq "مخاطر عالية"; PeriortyLevels.Name eq "أولوية عالية" | Projects→RiskLevels; Projects→PeriortyLevels | N | must keep the two dimensions separate |
| G08 | AR | delayed | المشاريع المتأخرة | list | Projects | Projects | Projects.EndDate lt today | — | N | no status column; date rule |
| G09 | EN | delayed | which projects are overdue? | list | Projects | Projects | Projects.EndDate lt today | — | N | |
| G10 | AR | delayed | كم عدد المشاريع المتأخرة؟ | count | Projects | Projects | Projects.EndDate lt today | — | N | |
| G11 | EN | due-soon | projects ending soon | list | Projects | Projects | Projects.EndDate between [today, +N] (relative "due_soon") | — | N | date_range relative |
| G12 | AR | dates | المشاريع التي تنتهي هذا الشهر | list | Projects | Projects | Projects.EndDate in current month | — | N | |
| G13 | AR | manager | من هو مدير هذا المشروع؟ | get_detail | Projects | AspNetUsers | (needs a specific project) | Projects→AspNetUsers | Y | "this project" unspecified |
| G14 | EN | manager | show projects by manager | summarize | Projects | AspNetUsers | group by manager | Projects→AspNetUsers | N | group/summarize |
| G15 | AR | manager | اعرض المشاريع الخاصة بمدير معيّن | list | Projects | AspNetUsers | AspNetUsers.FullName eq <?> | Projects→AspNetUsers | Y | which manager? |
| G16 | EN | manager | list projects managed by Ahmed | list | Projects | AspNetUsers | AspNetUsers.FullName eq "Ahmed" | Projects→AspNetUsers | N | value free-text (not a lookup); validate exists |
| G17 | AR | department | المشاريع حسب الإدارة | summarize | Projects | DepartmentLookups | group by department | Projects→DepartmentLookups | N | ImplementorDepartmentId |
| G18 | EN | department | projects in the Engineering department | list | Projects | DepartmentLookups | DepartmentLookups.Name eq "Engineering" | Projects→DepartmentLookups | Y | if "Engineering" not in lookup → clarify/invalid value |
| G19 | AR | department | كم مشروع في إدارة العمليات؟ | count | Projects | DepartmentLookups | DepartmentLookups.Name eq <validate> | Projects→DepartmentLookups | Y | validate value against DepartmentLookups |
| G20 | EN | lifecycle | projects by lifecycle stage | summarize | Projects | ProjectLifeCycleModels | group by lifecycle | Projects→ProjectLifeCycleModels | N | |
| G21 | AR | lifecycle | المشاريع في مرحلة دورة حياة معيّنة | list | Projects | ProjectLifeCycleModels | ProjectLifeCycleModels.Title eq <?> | Projects→ProjectLifeCycleModels | Y | which lifecycle? |
| G22 | EN | category | list projects by category | summarize | Projects | ProjectCategories | group by category | Projects→ProjectCategories | N | |
| G23 | AR | budget | المشاريع التي تزيد ميزانيتها عن مليون | list | Projects | Projects | Projects.Budget gt 1000000 | — | N | numeric filter |
| G24 | EN | budget | top projects by budget | list | Projects | Projects | sort Projects.Budget desc | — | N | sort, limit |
| G25 | AR | budget | إجمالي ميزانية المشاريع | summarize | Projects | Projects | agg sum(Projects.Budget) | — | N | aggregation |
| G26 | EN | budget | average project budget by department | summarize | Projects | Projects, DepartmentLookups | agg avg(Projects.Budget) group by department | Projects→DepartmentLookups | N | |
| G27 | AR | count | كم عدد المشاريع؟ | count | Projects | Projects | — | — | N | total count |
| G28 | EN | list | list all projects | list | Projects | Projects | — | — | N | |
| G29 | EN | compare | compare delayed vs on-time projects | compare | Projects | Projects | Projects.EndDate lt today vs >= today | — | N | derived from dates (no status) |
| G30 | AR | summary | قارن المشاريع حسب مستوى المخاطر | summarize | Projects | RiskLevels | group by RiskLevels.Name | Projects→RiskLevels | N | |
| G31 | EN | summary | summarize projects by risk level | summarize | Projects | RiskLevels | group by RiskLevels.Name | Projects→RiskLevels | N | |
| G32 | AR | summary | ملخص المشاريع حسب الأولوية | summarize | Projects | PeriortyLevels | group by PeriortyLevels.Name | Projects→PeriortyLevels | N | |
| G33 | AR | ambiguous-status | المشاريع المكتملة | — | Projects | Projects | (no status column) | — | Y | "completed": clarify (EndDate passed?) or unsupported |
| G34 | EN | ambiguous-status | show active projects | — | Projects | Projects | (no status column) | — | Y | no status concept → clarify/unsupported |
| G35 | AR | ambiguous-status | المشاريع المعلقة | unknown | Projects | — | — | — | Y | no "on hold" concept → clarify/unsupported |
| G36 | EN | unsupported | what's the weather today? | unknown | — | — | — | — | N | unsupported_reason set |
| G37 | AR | unsupported | اكتب لي قصيدة عن المشاريع | unknown | — | — | — | — | N | out of scope |
| G38 | EN | unsupported | delete all projects | unknown | — | — | — | — | N | no writes; unsupported |
| G39 | AR | unsupported | ما هي أعمدة جدول المستخدمين؟ | unknown | — | — | — | — | N | schema introspection / users → out of scope |
| G40 | EN | unsupported | show employee salaries | unknown | — | — | — | — | N | denylisted / no such data |
| G41 | AR | ambiguous | اعرض المشاريع المهمة | — | Projects | PeriortyLevels? RiskLevels? | — | — | Y | "المهمة/الهامة" ⇒ priority vs risk → clarify (the exact trap) |
| G42 | EN | ambiguous | show critical projects | — | Projects | RiskLevels? PeriortyLevels? | RiskLevels.Name eq "مخاطر عالية" (candidate) | Projects→RiskLevels | Y | "critical" ⇒ likely high risk, but clarify |
| G43 | AR | ambiguous | المشاريع الكبيرة | — | Projects | Projects | Projects.Budget (candidate) | — | Y | "big" ⇒ budget? outputs? → clarify |
| G44 | mixed | risk | show المشاريع high risk | list | Projects | RiskLevels | RiskLevels.Name eq "مخاطر عالية" | Projects→RiskLevels | N | mixed language |
| G45 | mixed | priority | قائمة projects بأولوية عالية | list | Projects | PeriortyLevels | PeriortyLevels.Name eq "أولوية عالية" | Projects→PeriortyLevels | N | mixed language |
| G46 | mixed | delayed | count المشاريع overdue | count | Projects | Projects | Projects.EndDate lt today | — | N | mixed language |
| G47 | EN | multi-filter | high risk projects in Finance department | list | Projects | RiskLevels, DepartmentLookups | RiskLevels.Name eq "مخاطر عالية"; DepartmentLookups.Name eq "Finance"(validate) | Projects→RiskLevels; Projects→DepartmentLookups | Y | two filters; dept value validated → maybe clarify |
| G48 | AR | multi-filter | المشاريع عالية المخاطر والمتأخرة | list | Projects | RiskLevels, Projects | RiskLevels.Name eq "مخاطر عالية"; Projects.EndDate lt today | Projects→RiskLevels | N | risk + date |
| G49 | EN | dates | projects starting next month | list | Projects | Projects | Projects.StartDate in next month | — | N | StartDate range |
| G50 | AR | manager+risk | مين المسؤول عن المشاريع عالية المخاطر؟ | list | Projects | AspNetUsers, RiskLevels | RiskLevels.Name eq "مخاطر عالية" | Projects→AspNetUsers; Projects→RiskLevels | N | responsible person of high-risk projects |

## Category coverage
risk (G01–04,44), priority (G05–06,45), risk-vs-priority (G07,41,42), delayed/overdue (G08–10,46,48), due-soon/dates (G11–12,49), manager/responsible (G13–16,50), department (G17–19,26,47), lifecycle (G20–21), category (G22), budget (G23–26,43), count vs list (G27–28), compare (G07,29), summary (G30–32), ambiguous status (G33–35), ambiguous concept (G41–43), invalid/unsupported (G36–40), Arabic (many), English (many), mixed (G44–46).

> Notes on "expected": values in a language other than the lookup's stored language (e.g. English "Finance" vs Arabic dept names) must be resolved by a lookup matcher; where the requested value is not in the enumerated set, the correct expected behavior is `needs_clarification` / invalid-value, **not** an invented value.
