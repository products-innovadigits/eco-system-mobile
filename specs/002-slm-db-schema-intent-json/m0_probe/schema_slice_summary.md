# M0 Schema Slice Summary (compact view of the real asset)

**Source:** `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`
(real `manual_sql_export`, root `dbo.Projects`, FK depth 2 — 61 tables / 104 relationships / 15 lookup sets).

This is a **compact, representative** view used to build the M0 prompts. The full
depth-2 export (61 tables) is too large to paste into the current Qwen2.5 1.5B
context, so the depth-2 probe prompt uses the business-critical sub-graph below.

## Root table
`Projects` — key columns:
`Id (PK), Name, NameEn, Description, StartDate, EndDate, Budget, OutputCount,`
`ManagerId (FK), ImplementorDepartmentId (FK), ImplementorDepartmentName,`
`SectionDepartmentId (FK), PeriortyLevelId (FK), ProjectCategoryId (FK),`
`LifeCycleId (FK), RiskLevelId (FK), IsDeleted`

> Note: `Projects` has **no direct status column**. "Delayed/overdue" must be
> expressed via `EndDate` vs. today. "Project status" is ambiguous (it maps to
> risk/process/step/challenge status tables, not to `Projects`).

## Critical related tables (direct FK targets — depth 1)
| Concept | Table | Label column | FK from Projects |
|---|---|---|---|
| Manager / responsible | `AspNetUsers` | `FullName` | `Projects.ManagerId -> AspNetUsers.Id` |
| Department (implementor) | `DepartmentLookups` | `Name` | `Projects.ImplementorDepartmentId -> DepartmentLookups.Id` |
| Department (section) | `DepartmentLookups` | `Name` | `Projects.SectionDepartmentId -> DepartmentLookups.Id` |
| Priority | `PeriortyLevels` | `Name` | `Projects.PeriortyLevelId -> PeriortyLevels.Id` |
| Category | `ProjectCategories` | `Name` | `Projects.ProjectCategoryId -> ProjectCategories.Id` |
| Lifecycle | `ProjectLifeCycleModels` | `Title` | `Projects.LifeCycleId -> ProjectLifeCycleModels.Id` |
| Risk level | `RiskLevels` | `Name` | `Projects.RiskLevelId -> RiskLevels.Id` |

## Manager / responsible relationship (sanitized identity)
`Projects.ManagerId -> AspNetUsers.Id` (FK `FK_Projects_AspNetUsers_ManagerId`).
`AspNetUsers` exposes only safe columns: `Id, FullName, UserName, IsActive,
NormalizedUserName`. Use `AspNetUsers.FullName` for "who is responsible / by manager".

## Risk / status / priority / department / lifecycle relationships (depth 2 chain)
- **Risk level:** `Projects.RiskLevelId -> RiskLevels.Id` (high-risk = `RiskLevels.Name = 'مخاطر عالية'`).
- **Risk detail (depth 2):** `RiskAssessment.ProjectId -> Projects.Id`, then
  `RiskAssessment.RiskClassificationId -> RiskClassifications.Id` and
  `RiskAssessment.StatusRiskId -> RiskStatuss.Id`; `RiskLogs.ProjectId -> Projects.Id`,
  `RiskLogs.RiskId -> RiskAssessment.Id`.
- **Challenges status (depth 2):** `Challenges.ProjectId -> Projects.Id`,
  `Challenges.StatusId -> ChallengeStatuses.Id`.
- **Team membership (depth 2):** `ProjectTeams.ProjectId -> Projects.Id`,
  `ProjectTeams.UserId -> AspNetUsers.Id`.
- **Priority:** `Projects.PeriortyLevelId -> PeriortyLevels.Id`.
- **Department:** `Projects.ImplementorDepartmentId / SectionDepartmentId -> DepartmentLookups.Id`.
- **Lifecycle:** `Projects.LifeCycleId -> ProjectLifeCycleModels.Id`.

## Key lookup values (from the real export, capped)
- `RiskLevels.Name` = [مخاطر عالية, مخاطر متوسطة, مخاطر منخفضة]
- `PeriortyLevels.Name` = [أولوية عالية, أولوية متوسطة, أولوية منخفضة]
- `RiskClassifications.Name` = [تقني, فني, مالي]
- `RiskStatuss.Name` = [تحقق, تم التعامل معه, مغلق, مفتوح]
- `ChallengeStatuses.Name` = [تم المعالجة, جاري المعالجة, لم تعالج]
- `DepartmentLookups.Name` = [Adminstration, Dep 2, Department A.K, Department X, Department Z, …]
- `ProjectCategories.Name`, `ProjectLifeCycleModels.Title` — free-text labels (no fixed enum).

## Tables included in the depth-2 probe prompt (14)
`Projects, AspNetUsers, DepartmentLookups, PeriortyLevels, ProjectCategories,
ProjectLifeCycleModels, RiskLevels, RiskAssessment, RiskClassifications,
RiskStatuss, RiskLogs, ProjectTeams, Challenges, ChallengeStatuses`.

## Tables included in the depth-1 fallback prompt (7)
`Projects, AspNetUsers, DepartmentLookups, PeriortyLevels, ProjectCategories,
ProjectLifeCycleModels, RiskLevels` (direct FK targets only; risk/challenge/team
detail chains dropped to shrink context).
