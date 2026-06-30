# Contract — Schema Metadata Asset

**File**: `assets/ai/schema/projects_db_metadata_schema.json`
**Produced by**: the manual SQL Server export script (`tools/schema_export/export_projects_schema.sql`), reviewed by a developer before commit.
**Consumed by**: `SchemaLoader` → `SchemaGraph` (on device).

This contract is **stable and future-ready**: a later automated CLI or backend/API MUST be able to emit a byte-compatible file without changing the on-device parser (FR-011). v1 uses a **single root**; the format reserves `roots` for future multi-root/multi-domain use.

## Top-level shape

```json
{
  "schema_version": "0.1.0",
  "generated_at": "2026-06-30T12:00:00Z",
  "root_table": "Projects",
  "extraction_summary": {
    "fk_depth": 2,
    "max_lookup_rows": 50,
    "samples_enabled": false,
    "denylist_applied": true,
    "source": "manual_sql_server_export"
  },
  "schema_metadata": {
    "tables": [
      {
        "name": "Projects",
        "primary_key": ["Id"],
        "columns": [
          { "name": "Id", "data_type": "int", "nullable": false, "is_lookup": false },
          { "name": "Name", "data_type": "nvarchar", "nullable": false, "is_lookup": false },
          { "name": "StatusId", "data_type": "int", "nullable": true, "is_lookup": true },
          { "name": "DueDate", "data_type": "datetime", "nullable": true, "is_lookup": false }
        ],
        "foreign_keys": [
          { "from_columns": ["StatusId"], "to_table": "ProjectStatus", "to_columns": ["Id"] }
        ]
      }
    ]
  },
  "lookup_values": [
    {
      "table": "ProjectStatus",
      "column": "Name",
      "values": ["Not Started", "In Progress", "Delayed", "Completed"]
    },
    {
      "table": "RiskLevel",
      "column": "Name",
      "values": ["Low", "Medium", "High", "Critical"]
    }
  ],
  "sample_values": []
}
```

## Field rules

| Field | Rule |
|---|---|
| `schema_version` | Semver. Parser supports a known major; unknown major → reject with a clear error. |
| `generated_at` | ISO-8601 UTC. Provenance only. |
| `root_table` | MUST exist in `schema_metadata.tables`. Single root in v1. |
| `extraction_summary.fk_depth` | Integer; v1 produces 2 (1 when depth-1 fallback export is used). |
| `extraction_summary.max_lookup_rows` | Cap actually applied; no `lookup_values[].values` array may exceed it. Default 50. |
| `extraction_summary.samples_enabled` | `false` by default; if `true`, `sample_values` may be non-empty and MUST have been reviewed. |
| `extraction_summary.denylist_applied` | MUST be `true`; signals sensitive tables/columns were filtered. |
| `schema_metadata.tables[]` | Root + FK-depth-2 neighbors. Each has `name`, `primary_key[]`, `columns[]`, `foreign_keys[]`. |
| `columns[].data_type` | SQL Server base type name (e.g. `int`, `nvarchar`, `datetime`, `bit`, `decimal`); drives operator compatibility. |
| `columns[].is_lookup` | `true` when the column is an enum/FK to a lookup table represented in `lookup_values`. |
| `foreign_keys[]` | `from_columns[]`, `to_table`, `to_columns[]`. `to_table` should resolve within the file. |
| `lookup_values[]` | Capped DISTINCT reference values for non-sensitive lookup tables. |
| `sample_values[]` | OFF by default; if present, capped + reviewed; never contains sensitive/PII data. |

## Security rules (enforced by the script + manual review)

- MUST exclude any table/column matching the documented denylist: `password, pass, pwd, token, secret, api_key, access_key, refresh_token, connection, connection_string, credential, private, ssn, national_id, passport, phone, mobile, email, address, salary, payment, card, tenant_secret, auth, otp, session, cookie`.
- MUST NEVER contain credentials, tokens, passwords, connection strings, secrets, private URLs, tenant secrets, or personal data.
- DB credentials never appear in this file or anywhere in the repo.

## Future-compatibility reservations (do not populate in v1)

- `roots: [...]` — reserved for multi-root extraction; v1 uses scalar `root_table`.
- `domain: "projects"` — reserved for multi-domain; assume "projects" when absent.

A future producer MAY add these keys; the v1 parser MUST ignore unknown top-level keys rather than fail.
