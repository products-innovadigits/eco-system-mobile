# M0 Probe Questions (15)

Paste these one at a time into the `<<PASTE ONE PROBE QUESTION HERE>>` slot of the
depth-2 prompt (and again into the depth-1 prompt). The **Expected** column is a
guideline for scoring — not an oracle; record what the model actually returns.

| ID | Language | Category | Question | Expected (guideline) |
|----|----------|----------|----------|----------------------|
| Q01 | ar | delayed + count | كم عدد المشاريع المتأخرة؟ | `count_records`, filter `Projects.EndDate < today`, status `ok` |
| Q02 | ar | high-risk + list | اعرض المشاريع عالية المخاطر | `list_records`, rel `Projects->RiskLevels`, filter `RiskLevels.Name = "مخاطر عالية"` |
| Q03 | en | delayed + priority + list | show delayed high priority projects | `list_records`, `EndDate < today` + `PeriortyLevels.Name = "أولوية عالية"` |
| Q04 | en | due-soon (date_range) | which projects are due soon? | `list_records`, `date_range.field = EndDate`, `relative = "due_soon"` |
| Q05 | ar | manager/responsible | من هو المسؤول عن المشاريع المتأخرة؟ | rel `Projects->AspNetUsers`, field `AspNetUsers.FullName`, `EndDate < today` |
| Q06 | en | summarize + department | summarize projects by department | `summarize_records`, rel `Projects->DepartmentLookups` |
| Q07 | en | department filter (lookup) | list projects in department "Department X" | `list_records`, `DepartmentLookups.Name = "Department X"` |
| Q08 | mixed | priority (mixed) | اعرض projects ذات الأولوية العالية | `list_records`, language `mixed`, `PeriortyLevels.Name = "أولوية عالية"` |
| Q09 | ar | manager filter | اعرض المشاريع الخاصة بمدير معيّن | rel `Projects->AspNetUsers` via `ManagerId`; may be `needs_clarification` (which manager?) |
| Q10 | en | count + category (group) | how many projects per category? | `count_records`/`summarize_records`, rel `Projects->ProjectCategories` |
| Q11 | mixed | high-risk + delayed | projects عالية المخاطر و delayed | language `mixed`, `RiskLevels.Name = "مخاطر عالية"` + `EndDate < today` |
| Q12 | ar | risk status (depth-2) | ما حالة المخاطر في المشاريع؟ | rel `Projects->RiskAssessment->RiskStatuss` (depth-2). On depth-1 prompt expect `unsupported`/`needs_clarification` |
| Q13 | ar | ambiguous status | ما حالة المشاريع؟ | `needs_clarification` (Projects has no status; clarify risk vs process vs challenge) |
| Q14 | en | unsupported (out of scope) | what is the weather today? | `unsupported`, `unknown` |
| Q15 | en | unsupported (sensitive/absent) | show employee salaries | `unsupported` or `invalid_schema_reference` (no salary field; identity sanitized) |

## Category coverage check
- Arabic: Q01, Q02, Q05, Q09, Q12, Q13
- English: Q03, Q04, Q06, Q07, Q10, Q14, Q15
- Mixed: Q08, Q11
- High-risk: Q02, Q11
- Delayed/overdue: Q01, Q03, Q05, Q11
- Manager/responsible: Q05, Q09
- Department: Q06, Q07
- Priority: Q03, Q08
- Status: Q12, Q13
- Count/list/summarize: Q01, Q02, Q06, Q07, Q10
- Ambiguous: Q09 (mild), Q13 (clear)
- Unsupported: Q14, Q15

> Q12 is deliberately a **depth-2** question (risk status chain). It is the key
> test for whether depth-2 context is needed vs. the depth-1 fallback.
