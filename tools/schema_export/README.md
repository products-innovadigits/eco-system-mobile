# Projects Schema Export Runbook

This folder contains the manual, read-only SQL Server export scaffold for feature `002-slm-db-schema-intent-json`.

The export is off-device. Flutter must never connect to SQL Server, execute SQL, retrieve live data, or receive credentials.

## What This Produces

The reviewed output is saved as:

`systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`

The file must follow:

`specs/002-slm-db-schema-intent-json/contracts/schema_metadata_contract.md`

## Before Running

1. Use SSMS or `sqlcmd` with read-only SQL Server access.
2. Keep DB credentials outside the repository.
3. Manually discover the single projects-domain root table. Do not assume it is named `Projects`.
4. Open `export_projects_schema.sql`.
5. Set:
   - `@RootSchema`
   - `@RootTable`
   - `@FkDepth` (default `2`)
   - `@MaxLookupRows` (default `50`)
6. Leave `@SamplesEnabled = 0` for M0.

## Run (DBeaver)

The script is packaged as a **temporary stored procedure** with `GO` batch
separators (this avoids DBeaver's statement-splitter choking on big quoted
strings, which causes `sp_executesql expects parameter '@statement'`).

1. Open the script in a SQL editor connected (read-only) to the projects DB.
2. **Select all (Ctrl+A)** and run **Execute SQL Script (Alt+X)** — *not*
   Execute Statement (Ctrl+Enter). With `GO` present, DBeaver runs the three
   batches in order: drop temp proc → create temp proc → `EXEC`.
3. Two result tabs appear. In tab 1 confirm `is_valid_json = 1`.

If DBeaver does not recognize `GO`: enable it under
Preferences → Editors → SQL Editor → (SQL Processing) "Use server-side GO" /
batch delimiter — or run the three `GO`-separated batches one at a time.

In SSMS / `sqlcmd` the same script runs as-is (GO is native there). It only
reads SQL Server catalog metadata and emits JSON using `FOR JSON PATH`.

The scaffold intentionally avoids:

- credentials
- DML or DDL
- stored procedure execution
- Flutter database access
- Python CLI automation
- live transactional row export

## Review Checklist

Before committing the JSON asset, confirm:

- `schema_version` is present.
- `generated_at` is present and UTC-like.
- `root_table` is the chosen single root.
- `extraction_summary.fk_depth` is recorded.
- `extraction_summary.max_lookup_rows` is recorded.
- `extraction_summary.samples_enabled` is `false`.
- `extraction_summary.denylist_applied` is `true`.
- `schema_metadata.tables[]` includes the root and FK-depth neighbors.
- Each table includes columns, primary key, and foreign keys where available.
- `lookup_values[]` contains only safe capped reference values.
- No `lookup_values[].values` array exceeds `max_lookup_rows`.
- `sample_values` is empty for M0.

## Sensitive-Field Denylist

Exclude any table or column whose name contains one of:

`password`, `pass`, `pwd`, `token`, `secret`, `api_key`, `access_key`, `refresh_token`, `connection`, `connection_string`, `credential`, `private`, `ssn`, `national_id`, `passport`, `phone`, `mobile`, `email`, `address`, `salary`, `payment`, `card`, `tenant_secret`, `auth`, `otp`, `session`, `cookie`.

The asset must never contain credentials, tokens, passwords, connection strings, secrets, private URLs, tenant secrets, or sensitive personal data.

## Identity / User Tables — sanitized `AspNetUsers` policy

`dbo.AspNetUsers` holds the **project manager / responsible user** referenced by
`dbo.Projects.ManagerId -> dbo.AspNetUsers.Id`. This is business-critical for
the AI Assistant ("who is responsible for this project?", "show projects by
manager", "مين المسؤول عن المشروع؟"), so the table is **included — but only in
sanitized, manager-reference mode**:

- It is kept in `schema_metadata.tables` with a **strict column allowlist**:
  `Id, UserName, NormalizedUserName, FullName, Name, FirstName, LastName,
  ArabicName, EnglishName, DisplayName, IsActive, IsDeleted`.
  Columns from the allowlist that do not exist in the real table are simply skipped.
- The `Projects.ManagerId -> AspNetUsers.Id` foreign key is preserved in both
  `schema_metadata.tables[].foreign_keys` and `schema_metadata.relationships`.
- A **forbidden-pattern guard** plus the global denylist still apply on top, so
  identity/security/PII columns are never emitted, e.g. `PasswordHash`,
  `SecurityStamp`, `ConcurrencyStamp`, `Email`/`NormalizedEmail`/`EmailConfirmed`,
  `PhoneNumber`/`PhoneNumberConfirmed`, `TwoFactorEnabled`,
  `LockoutEnd`/`LockoutEnabled`, `AccessFailedCount`, and anything matching
  `stamp, claim, login, auth, session, cookie, otp, private, address, salary,
  payment, card, national_id, passport, token, secret, password`.
- **All other identity tables stay fully excluded**: `AspNetRoles`,
  `AspNetUserRoles`, `AspNetUserClaims`, `AspNetRoleClaims`, `AspNetUserLogins`,
  `AspNetUserTokens`. They appear in `extraction_summary.excluded_tables` with
  reason `identity_security`.

### Manager lookup values (optional, OFF by default)

By default the export does **not** dump user rows. It only exposes the schema
relationship + safe display columns so the SLM understands that `ManagerId`
maps to a manager.

If you want capped manager labels, set `@IncludeManagerLookup = 1`. When enabled
it adds, under `lookup_values`, **only project managers actually referenced by
`Projects.ManagerId`**, capped at `@MaxLookupRows` (50), using a single safe
display column (first available of `DisplayName, FullName, Name, EnglishName,
ArabicName, UserName`). That entry is tagged `"reference_role":
"manager_responsible"`. It never includes email/phone/auth fields and never
exports raw user rows.

## Running the export (requires a configured SQL Server connection)

This script must be executed against the real SQL Server database by a developer
with read-only access — from DBeaver (preferred) or any SQL Server client. There
is **no automated runner in this repository**, and the Flutter app never connects
to SQL Server. If no SQL Server connection is configured in your environment, the
export cannot run; do not hand-fabricate the asset as if it were a real export.

DB credentials/connection details stay outside the repository and outside Flutter.

## If SQL Server Access Is Not Available

For M0, create a representative contract-compliant projects schema sample and mark it as representative in `research.md`.

The representative asset may be used for context-size and prompt-shape preparation, but G-M0 cannot pass until the real Samsung S22 Ultra measurement is performed with the current Qwen2.5 1.5B model.

## Manual Assembly Notes

The SQL scaffold may emit nested JSON fragments. It is acceptable to copy those fragments into the final stable contract manually, provided the final file is reviewed and saved under the Flutter asset path.

Keep the final top-level shape:

```json
{
  "schema_version": "0.1.0",
  "generated_at": "2026-06-30T00:00:00Z",
  "root_table": "Projects",
  "extraction_summary": {
    "fk_depth": 2,
    "max_lookup_rows": 50,
    "samples_enabled": false,
    "denylist_applied": true,
    "source": "manual_sql_server_export"
  },
  "schema_metadata": { "tables": [] },
  "lookup_values": [],
  "sample_values": []
}
```

## Replacement Flow

When the real export is available:

1. Run the scaffold manually.
2. Review and assemble the contract-compliant JSON.
3. Replace `systems/project_management/assets/ai/schema/projects_db_metadata_schema.json`.
4. Update `specs/002-slm-db-schema-intent-json/research.md` with provenance and review notes.
5. Re-run M0 measurement on Samsung Galaxy S22 Ultra.
