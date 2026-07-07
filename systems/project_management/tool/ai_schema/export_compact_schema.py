#!/usr/bin/env python3
"""
Compact schema extractor for the local SLM benchmark.

Reads SQL Server credentials from an .env file (SQL_CONNECTION_STRING), connects
read-only to Nawah_dev.dbo, inspects metadata (tables/columns/PKs/FKs), builds the
FK graph, selects only tables connected to the root table(s) at depth 1, and writes
a compact pseudo-object schema text file for prompt injection.

Security / safety rules enforced here:
  * Only sys.* metadata catalog views are queried (no business rows).
  * No INSERT/UPDATE/DELETE/DDL is issued.
  * The connection string / credentials are never printed.
  * Nothing is copied from the .env into this source or the output.

Usage:
  python export_compact_schema.py            # dry-run summary only
  python export_compact_schema.py --write    # dry-run summary + write output file
  python export_compact_schema.py --env /path/to/.env --write
"""

from __future__ import annotations

import argparse
import os
import sys
from collections import defaultdict

try:
    import pyodbc
except ImportError:  # pragma: no cover
    sys.stderr.write("pyodbc is required. Run with the rag_first venv python.\n")
    sys.exit(2)

DB = "Nawah_dev"
SCHEMA = "dbo"
DEFAULT_ENV = "/Users/macbook/StudioProjects/rag_first/.env"
OUTPUT_PATH = os.path.join(
    os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
    "assets", "ai", "schema", "nawah_compact_schema_no_terms.v1.txt",
)

ROOT_TABLES = ["Projects"]  # meeting root resolved dynamically (do not invent)

# Columns to KEEP for security/identity tables. Everything else on these tables
# (password/token/security/lockout fields, etc.) is excluded.
USER_TABLE_WHITELIST = {"Id", "FullName", "UserName", "Name", "DisplayName"}
SECURITY_TABLE_NAMES = {"AspNetUsers"}

# Compact data-type mapping.
TYPE_MAP = {
    "nvarchar": "string", "varchar": "string", "nchar": "string",
    "char": "string", "sysname": "string",
    "text": "text", "ntext": "text",
    "bigint": "bigint", "int": "int", "smallint": "smallint", "tinyint": "tinyint",
    "bit": "bit",
    "decimal": "decimal", "numeric": "decimal", "money": "decimal",
    "smallmoney": "decimal",
    "float": "float", "real": "float",
    "datetime": "datetime", "datetime2": "datetime", "smalldatetime": "datetime",
    "datetimeoffset": "datetime",
    "date": "date", "time": "time",
    "uniqueidentifier": "uniqueidentifier",
    "varbinary": "binary", "binary": "binary", "image": "binary",
    "geography": "geography", "geometry": "geometry", "xml": "xml",
    "hierarchyid": "hierarchyid", "timestamp": "binary", "rowversion": "binary",
}


def load_connection_string(env_path: str) -> str:
    if not os.path.isfile(env_path):
        sys.stderr.write(f"env file not found: {env_path}\n")
        sys.exit(2)
    conn = None
    with open(env_path, "r", encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, _, value = line.partition("=")
            if key.strip() == "SQL_CONNECTION_STRING":
                conn = value.strip().strip('"').strip("'")
                break
    if not conn:
        sys.stderr.write("SQL_CONNECTION_STRING missing in .env\n")
        sys.exit(2)
    return conn


def compact_type(type_name: str) -> str:
    return TYPE_MAP.get(type_name.lower(), type_name.lower())


def fetch_metadata(cur):
    """Query sys.* catalog views (read-only) scoped to Nawah_dev.dbo."""
    # Tables
    cur.execute(f"""
        SELECT t.object_id, t.name
        FROM {DB}.sys.tables t
        JOIN {DB}.sys.schemas s ON t.schema_id = s.schema_id
        WHERE s.name = ?
    """, SCHEMA)
    tables = {row.object_id: row.name for row in cur.fetchall()}

    # Columns
    cur.execute(f"""
        SELECT c.object_id, c.column_id, c.name,
               ty.name AS type_name, c.is_computed
        FROM {DB}.sys.columns c
        JOIN {DB}.sys.types ty ON c.user_type_id = ty.user_type_id
        JOIN {DB}.sys.tables t ON c.object_id = t.object_id
        JOIN {DB}.sys.schemas s ON t.schema_id = s.schema_id
        WHERE s.name = ?
        ORDER BY c.object_id, c.column_id
    """, SCHEMA)
    columns = defaultdict(list)  # object_id -> [(col_name, type_name, is_computed)]
    for row in cur.fetchall():
        columns[row.object_id].append((row.name, row.type_name, bool(row.is_computed)))

    # Primary keys
    cur.execute(f"""
        SELECT ic.object_id, c.name
        FROM {DB}.sys.indexes i
        JOIN {DB}.sys.index_columns ic
             ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        JOIN {DB}.sys.columns c
             ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE i.is_primary_key = 1
    """)
    pks = defaultdict(set)  # object_id -> {col_name}
    for row in cur.fetchall():
        pks[row.object_id].add(row.name)

    # Foreign keys
    cur.execute(f"""
        SELECT fkc.parent_object_id, pc.name AS parent_col,
               fkc.referenced_object_id, rc.name AS ref_col
        FROM {DB}.sys.foreign_keys fk
        JOIN {DB}.sys.foreign_key_columns fkc
             ON fk.object_id = fkc.constraint_object_id
        JOIN {DB}.sys.columns pc
             ON fkc.parent_object_id = pc.object_id
            AND fkc.parent_column_id = pc.column_id
        JOIN {DB}.sys.columns rc
             ON fkc.referenced_object_id = rc.object_id
            AND fkc.referenced_column_id = rc.column_id
    """)
    fks = []  # (parent_oid, parent_col, ref_oid, ref_col)
    for row in cur.fetchall():
        fks.append((row.parent_object_id, row.parent_col,
                    row.referenced_object_id, row.ref_col))

    return tables, columns, pks, fks


def build_graph(tables, fks):
    """Undirected adjacency of object_ids connected by any FK edge."""
    adj = defaultdict(set)
    for parent_oid, _, ref_oid, _ in fks:
        if parent_oid in tables and ref_oid in tables:
            adj[parent_oid].add(ref_oid)
            adj[ref_oid].add(parent_oid)
    return adj


def neighbors_at_depth(roots, adj, depth):
    """Set of object_ids within `depth` FK hops of any root (roots included)."""
    seen = set(roots)
    frontier = set(roots)
    for _ in range(depth):
        nxt = set()
        for oid in frontier:
            nxt |= adj.get(oid, set())
        nxt -= seen
        seen |= nxt
        frontier = nxt
        if not frontier:
            break
    return seen


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--env", default=DEFAULT_ENV)
    ap.add_argument("--write", action="store_true")
    args = ap.parse_args()

    conn_str = load_connection_string(args.env)
    conn = pyodbc.connect(conn_str)
    conn.autocommit = True  # read-only metadata; no transactions to commit
    cur = conn.cursor()

    tables, columns, pks, fks = fetch_metadata(cur)
    conn.close()

    name_by_oid = tables
    oid_by_name = {v: k for k, v in tables.items()}

    # Resolve roots
    root_oids = []
    root_found, root_missing = [], []
    for rt in ROOT_TABLES:
        if rt in oid_by_name:
            root_oids.append(oid_by_name[rt])
            root_found.append(rt)
        else:
            root_missing.append(rt)

    # Meeting-root discovery (do NOT invent)
    meeting_candidates = sorted(
        n for n in oid_by_name if "meeting" in n.lower()
    )
    meeting_included = False
    meeting_note = "left pending (no exact 'Meetings' table)"
    if "Meetings" in oid_by_name:
        root_oids.append(oid_by_name["Meetings"])
        root_found.append("Meetings")
        meeting_included = True
        meeting_note = "included (exact 'Meetings' table found)"
    elif meeting_candidates:
        meeting_note = f"AMBIGUOUS candidates -> {', '.join(meeting_candidates)}"

    adj = build_graph(tables, fks)

    # Isolated tables (no FK edge at all)
    isolated = [name_by_oid[o] for o in tables if o not in adj]

    if not root_found or "Projects" not in root_found:
        print("=" * 60)
        print("DRY-RUN SUMMARY")
        print("=" * 60)
        print(f"total {SCHEMA} tables : {len(tables)}")
        print(f"root tables found   : {root_found}")
        print(f"root tables missing : {root_missing}")
        print(f"meeting candidates  : {meeting_candidates or 'none'}")
        print("\nSTOP: 'Projects' root table not found. Nothing written.")
        sys.exit(1)

    d1 = neighbors_at_depth(root_oids, adj, 1)
    d2 = neighbors_at_depth(root_oids, adj, 2)

    included = d1
    included_names = sorted(name_by_oid[o] for o in included)
    excluded_count = len(tables) - len(included)

    # FK edges fully inside the included set
    included_edges = []
    for parent_oid, pcol, ref_oid, rcol in fks:
        if parent_oid in included and ref_oid in included:
            included_edges.append(
                (name_by_oid[parent_oid], pcol, name_by_oid[ref_oid], rcol)
            )
    # de-dup & stable order
    included_edges = sorted(set(included_edges))

    text = render_schema(included, name_by_oid, columns, pks,
                         included_edges, fks)

    # ---- Dry-run summary ----
    print("=" * 60)
    print("DRY-RUN SUMMARY")
    print("=" * 60)
    print(f"root tables found            : {root_found}")
    print(f"root tables missing          : {root_missing or 'none'}")
    print(f"total {SCHEMA} tables            : {len(tables)}")
    print(f"total FK relationships       : {len(fks)}")
    print(f"included tables (depth 1)    : {len(d1)}")
    print(f"included tables (depth 2)    : {len(d2)}")
    print(f"excluded isolated tables     : {len(isolated)}")
    print(f"excluded unrelated (to root) : {excluded_count}")
    print(f"included FK relationships    : {len(included_edges)}")
    print(f"estimated output chars       : {len(text)}")
    print(f"meeting root                 : {meeting_note}")
    print(f"\nincluded tables ({len(included_names)}):")
    for n in included_names:
        print(f"  - {n}")

    if args.write:
        os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)
        with open(OUTPUT_PATH, "w", encoding="utf-8") as fh:
            fh.write(text)
        print(f"\nWROTE: {OUTPUT_PATH}")
        print(f"chars written: {len(text)}")
    else:
        print("\n(dry-run only; pass --write to generate the file)")


def render_schema(included, name_by_oid, columns, pks, included_edges, fks):
    # Map (parent_oid, parent_col) -> (ref_table, ref_col) for inline FK rendering
    fk_by_col = {}
    for parent_oid, pcol, ref_oid, rcol in fks:
        if parent_oid in included and ref_oid in included:
            fk_by_col[(parent_oid, pcol)] = (name_by_oid[ref_oid], rcol)

    lines = ["Nawah {"]
    ordered = sorted(included, key=lambda o: name_by_oid[o])
    for i, oid in enumerate(ordered):
        tname = name_by_oid[oid]
        is_security = tname in SECURITY_TABLE_NAMES
        pk_cols = pks.get(oid, set())
        col_lines = []
        for cname, ctype, is_computed in columns.get(oid, []):
            if is_computed:
                continue
            # On security tables keep only whitelisted columns, but always keep
            # structural FK columns so the body stays consistent with Relations.
            if is_security and cname not in USER_TABLE_WHITELIST \
                    and (oid, cname) not in fk_by_col:
                continue
            entry = f"{cname}: {compact_type(ctype)}"
            if cname in pk_cols:
                entry += " pk"
            fk = fk_by_col.get((oid, cname))
            if fk:
                entry += f" -> {fk[0]}.{fk[1]}"
            col_lines.append(entry)
        lines.append(f"  {tname} {{")
        for j, cl in enumerate(col_lines):
            comma = "," if j < len(col_lines) - 1 else ""
            lines.append(f"    {cl}{comma}")
        lines.append("  },")
        lines.append("")

    lines.append("  Relations {")
    for k, (pt, pc, rt, rc) in enumerate(included_edges):
        comma = "," if k < len(included_edges) - 1 else ""
        lines.append(f"    {pt}.{pc} -> {rt}.{rc}{comma}")
    lines.append("  }")
    lines.append("}")
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    main()
