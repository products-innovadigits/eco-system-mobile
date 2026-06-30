/*
  Projects schema metadata export (DBeaver-safe via temporary stored procedure).
  Read-only. SQL Server compatibility 160. Root = dbo.Projects, FK depth = 2.

  HOW TO RUN IN DBEAVER:
    Select all (Ctrl+A) and run "Execute SQL Script" (Alt+X).
    The script uses GO batch separators, so it runs as 3 batches:
      1) drop the temp proc if it exists
      2) create the temp proc (#usp_export_projects_schema)
      3) EXEC it -> returns 2 result sets

  RESULT SETS:
    1) json_payload (full JSON) + is_valid_json + total_length
    2) chunk_index / chunk_text / total_length / total_chunks  (for safe copy)

  Identity/security policy:
    - dbo.AspNetUsers IS INCLUDED, but ONLY as a sanitized manager/responsible
      reference table: strict column allowlist + forbidden-pattern guard +
      global denylist. Keeps Projects.ManagerId -> AspNetUsers.Id.
    - ALL other AspNet* identity tables remain EXCLUDED.
    - User rows are NOT exported as lookup values by default. Optional capped,
      safe-display-only manager lookup: set @IncludeManagerLookup = 1 below.
*/

IF OBJECT_ID('tempdb..#usp_export_projects_schema') IS NOT NULL
    DROP PROCEDURE #usp_export_projects_schema;
GO

CREATE PROCEDURE #usp_export_projects_schema
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    /* ---- Config (edit here) ---- */
    DECLARE @SchemaVer          nvarchar(20) = N'0.1.0';
    DECLARE @RootSchema         sysname      = N'dbo';
    DECLARE @RootTable          sysname      = N'Projects';
    DECLARE @DbType             nvarchar(50) = N'sql_server';
    DECLARE @Method             nvarchar(50) = N'manual_sql_export';
    DECLARE @FkDepth            int          = 2;
    DECLARE @MaxLookupRows      int          = 50;
    DECLARE @MaxLookupTableRows int          = 500;
    DECLARE @IncludeManagerLookup bit        = 0;     -- set 1 to include capped manager names
    DECLARE @ChunkSize          int          = 8000;
    DECLARE @MgrRefSchema       sysname      = N'dbo';
    DECLARE @MgrRefTable        sysname      = N'AspNetUsers';

    DECLARE @DenyCsv nvarchar(max) =
        N'password,pass,pwd,token,secret,api_key,access_key,refresh_token,connection,connection_string,credential,private,ssn,national_id,passport,phone,mobile,email,address,salary,payment,card,tenant_secret,auth,otp,session,cookie';
    /* AspNetUsers intentionally NOT here (kept as sanitized manager ref). */
    DECLARE @IdentityCsv nvarchar(max) =
        N'AspNetRoles,AspNetUserRoles,AspNetUserClaims,AspNetRoleClaims,AspNetUserLogins,AspNetUserTokens';
    DECLARE @MgrRefCsv nvarchar(max) = N'AspNetUsers';
    DECLARE @UserAllowCsv nvarchar(max) =
        N'id,username,normalizedusername,fullname,name,firstname,lastname,arabicname,englishname,displayname,isactive,isdeleted';
    DECLARE @UserForbidCsv nvarchar(max) =
        N'passwordhash,securitystamp,concurrencystamp,email,normalizedemail,emailconfirmed,phonenumber,phonenumberconfirmed,phone,twofactor,lockout,accessfailed,stamp,claim,login,auth,session,cookie,otp,private,address,salary,payment,card,national_id,passport,token,secret,password';
    DECLARE @TablePatCsv nvarchar(max) =
        N'risk,status,priority,periorty,department,category,lifecycle,stage,workflow,level,lookup,type';
    DECLARE @ColPatCsv nvarchar(max) =
        N'name,title,label,code,status,desc,level,type,category,stage,priority,periorty';

    DECLARE @Root int = OBJECT_ID(QUOTENAME(@RootSchema) + N'.' + QUOTENAME(@RootTable), N'U');
    IF @Root IS NULL THROW 50001, N'Root table not found. Check @RootSchema/@RootTable.', 1;

    /* ---- Config lists -> temp tables ---- */
    CREATE TABLE #deny      (term nvarchar(100));
    CREATE TABLE #identity  (name nvarchar(128));
    CREATE TABLE #mgrref    (name nvarchar(128));
    CREATE TABLE #userallow (name nvarchar(128));
    CREATE TABLE #userforbid(term nvarchar(128));
    CREATE TABLE #tp        (term nvarchar(100));
    CREATE TABLE #cp        (term nvarchar(100));

    INSERT INTO #deny(term)       SELECT LOWER(LTRIM(RTRIM(value))) FROM STRING_SPLIT(@DenyCsv, N',')      WHERE LEN(LTRIM(RTRIM(value))) > 0;
    INSERT INTO #identity(name)   SELECT LTRIM(RTRIM(value))        FROM STRING_SPLIT(@IdentityCsv, N',')  WHERE LEN(LTRIM(RTRIM(value))) > 0;
    INSERT INTO #mgrref(name)     SELECT LTRIM(RTRIM(value))        FROM STRING_SPLIT(@MgrRefCsv, N',')    WHERE LEN(LTRIM(RTRIM(value))) > 0;
    INSERT INTO #userallow(name)  SELECT LOWER(LTRIM(RTRIM(value))) FROM STRING_SPLIT(@UserAllowCsv, N',') WHERE LEN(LTRIM(RTRIM(value))) > 0;
    INSERT INTO #userforbid(term) SELECT LOWER(LTRIM(RTRIM(value))) FROM STRING_SPLIT(@UserForbidCsv, N',')WHERE LEN(LTRIM(RTRIM(value))) > 0;
    INSERT INTO #tp(term)         SELECT LOWER(LTRIM(RTRIM(value))) FROM STRING_SPLIT(@TablePatCsv, N',')  WHERE LEN(LTRIM(RTRIM(value))) > 0;
    INSERT INTO #cp(term)         SELECT LOWER(LTRIM(RTRIM(value))) FROM STRING_SPLIT(@ColPatCsv, N',')    WHERE LEN(LTRIM(RTRIM(value))) > 0;

    /* ---- FK depth traversal (both directions) ---- */
    ;WITH edges AS (
        SELECT parent_object_id AS a, referenced_object_id AS b FROM sys.foreign_keys
        UNION
        SELECT referenced_object_id AS a, parent_object_id AS b FROM sys.foreign_keys
    ),
    walk AS (
        SELECT @Root AS oid, 0 AS depth, CAST(N',' + CONVERT(nvarchar(20), @Root) + N',' AS nvarchar(max)) AS path
        UNION ALL
        SELECT e.b, w.depth + 1, w.path + CONVERT(nvarchar(20), e.b) + N','
        FROM walk w
        JOIN edges e ON e.a = w.oid
        WHERE w.depth < @FkDepth
          AND CHARINDEX(N',' + CONVERT(nvarchar(20), e.b) + N',', w.path) = 0
    )
    SELECT oid, MIN(depth) AS depth INTO #reached FROM walk GROUP BY oid OPTION (MAXRECURSION 1000);

    SELECT r.oid, r.depth, s.name AS schema_name, t.name AS table_name
    INTO #tabs
    FROM #reached r
    JOIN sys.tables t  ON t.object_id = r.oid
    JOIN sys.schemas s ON s.schema_id = t.schema_id;

    SELECT x.oid, x.schema_name, x.table_name,
           CASE WHEN i.name IS NOT NULL THEN N'identity_security' ELSE N'denylist' END AS reason
    INTO #excluded
    FROM #tabs x
    LEFT JOIN #identity i ON i.name = x.table_name
    WHERE x.oid <> @Root
      AND NOT EXISTS (SELECT 1 FROM #mgrref m WHERE m.name = x.table_name)
      AND ( i.name IS NOT NULL
            OR EXISTS (SELECT 1 FROM #deny d WHERE LOWER(x.table_name) LIKE N'%' + d.term + N'%') );

    SELECT x.oid, x.depth, x.schema_name, x.table_name,
           CONVERT(bit, CASE WHEN EXISTS (SELECT 1 FROM #mgrref m WHERE m.name = x.table_name) THEN 1 ELSE 0 END) AS is_mgr_ref
    INTO #included
    FROM #tabs x
    WHERE NOT EXISTS (SELECT 1 FROM #excluded e WHERE e.oid = x.oid);

    /* ---- tables[] ---- */
    DECLARE @tablesJson nvarchar(max) =
    (
      SELECT
        it.schema_name AS table_schema,
        it.table_name  AS table_name,
        it.depth       AS depth,
        it.is_mgr_ref  AS is_manager_reference,
        JSON_QUERY(ISNULL((
          SELECT
            c.name       AS column_name,
            ty.name      AS data_type,
            c.max_length AS max_length,
            c.precision  AS precision_value,
            c.scale      AS scale_value,
            CONVERT(bit, c.is_nullable) AS is_nullable,
            CONVERT(bit, c.is_identity) AS is_identity,
            CONVERT(bit, CASE WHEN pk.column_id IS NOT NULL THEN 1 ELSE 0 END) AS is_primary_key,
            CONVERT(bit, CASE WHEN fkc.parent_column_id IS NOT NULL THEN 1 ELSE 0 END) AS is_foreign_key
          FROM sys.columns c
          JOIN sys.types ty ON ty.user_type_id = c.user_type_id
          LEFT JOIN (
            SELECT ic.object_id, ic.column_id
            FROM sys.index_columns ic
            JOIN sys.indexes i ON i.object_id = ic.object_id AND i.index_id = ic.index_id
            WHERE i.is_primary_key = 1
          ) pk ON pk.object_id = c.object_id AND pk.column_id = c.column_id
          LEFT JOIN (
            SELECT DISTINCT parent_object_id, parent_column_id FROM sys.foreign_key_columns
          ) fkc ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
          WHERE c.object_id = it.oid
            AND (
                  ( it.is_mgr_ref = 1
                    AND EXISTS (SELECT 1 FROM #userallow ua WHERE ua.name = LOWER(c.name))
                    AND NOT EXISTS (SELECT 1 FROM #userforbid uf WHERE LOWER(c.name) LIKE N'%' + uf.term + N'%')
                    AND NOT EXISTS (SELECT 1 FROM #deny d WHERE LOWER(c.name) LIKE N'%' + d.term + N'%') )
                  OR
                  ( it.is_mgr_ref = 0
                    AND NOT EXISTS (SELECT 1 FROM #deny d WHERE LOWER(c.name) LIKE N'%' + d.term + N'%') )
                )
          ORDER BY c.column_id
          FOR JSON PATH
        ), N'[]')) AS [columns],
        JSON_QUERY(ISNULL((
          SELECT
            fk.name AS fk_name,
            OBJECT_SCHEMA_NAME(fk.parent_object_id)     AS from_schema,
            OBJECT_NAME(fk.parent_object_id)            AS from_table,
            COL_NAME(fkc.parent_object_id, fkc.parent_column_id)         AS from_column,
            OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS to_schema,
            OBJECT_NAME(fk.referenced_object_id)        AS to_table,
            COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS to_column
          FROM sys.foreign_keys fk
          JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
          WHERE fk.parent_object_id = it.oid
            AND EXISTS (SELECT 1 FROM #included ti WHERE ti.oid = fk.referenced_object_id)
            AND NOT EXISTS (SELECT 1 FROM #deny d WHERE LOWER(COL_NAME(fkc.parent_object_id, fkc.parent_column_id)) LIKE N'%' + d.term + N'%')
          ORDER BY fk.name, fkc.constraint_column_id
          FOR JSON PATH
        ), N'[]')) AS foreign_keys
      FROM #included it
      ORDER BY it.depth, it.schema_name, it.table_name
      FOR JSON PATH
    );
    SET @tablesJson = ISNULL(@tablesJson, N'[]');

    /* ---- relationships[] ---- */
    DECLARE @relsJson nvarchar(max) = ISNULL((
      SELECT
        fk.name AS fk_name,
        OBJECT_SCHEMA_NAME(fk.parent_object_id)     AS from_schema,
        OBJECT_NAME(fk.parent_object_id)            AS from_table,
        COL_NAME(fkc.parent_object_id, fkc.parent_column_id)         AS from_column,
        OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS to_schema,
        OBJECT_NAME(fk.referenced_object_id)        AS to_table,
        COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS to_column
      FROM sys.foreign_keys fk
      JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
      WHERE EXISTS (SELECT 1 FROM #included a WHERE a.oid = fk.parent_object_id)
        AND EXISTS (SELECT 1 FROM #included b WHERE b.oid = fk.referenced_object_id)
        AND NOT EXISTS (SELECT 1 FROM #deny d WHERE LOWER(COL_NAME(fkc.parent_object_id, fkc.parent_column_id)) LIKE N'%' + d.term + N'%')
      ORDER BY fk.name, fkc.constraint_column_id
      FOR JSON PATH
    ), N'[]');

    /* ---- lookup candidates (non-manager tables only) ---- */
    SELECT it.oid, it.schema_name, it.table_name, c.name AS column_name
    INTO #cand
    FROM #included it
    JOIN sys.columns c ON c.object_id = it.oid
    JOIN sys.types ty  ON ty.user_type_id = c.user_type_id
    WHERE it.is_mgr_ref = 0
      AND ty.name IN (N'char', N'varchar', N'nchar', N'nvarchar')
      AND NOT EXISTS (SELECT 1 FROM #deny d WHERE LOWER(c.name) LIKE N'%' + d.term + N'%')
      AND EXISTS (SELECT 1 FROM #tp p WHERE LOWER(it.table_name) LIKE N'%' + p.term + N'%')
      AND EXISTS (SELECT 1 FROM #cp p WHERE LOWER(c.name)        LIKE N'%' + p.term + N'%');

    DELETE c
    FROM #cand c
    WHERE ( SELECT ISNULL(SUM(p.rows), 0)
            FROM sys.partitions p
            WHERE p.object_id = c.oid AND p.index_id IN (0, 1) ) > @MaxLookupTableRows;

    CREATE TABLE #vals (schema_name sysname, table_name sysname, column_name sysname, [value] nvarchar(400), role nvarchar(40) NULL);

    DECLARE @sch sysname, @tab sysname, @col sysname, @dyn nvarchar(max);
    DECLARE cur CURSOR LOCAL FAST_FORWARD FOR SELECT schema_name, table_name, column_name FROM #cand;
    OPEN cur;
    FETCH NEXT FROM cur INTO @sch, @tab, @col;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @dyn =
            N'SELECT @s AS schema_name, @t AS table_name, @c AS column_name, v.[value] FROM (' +
            N'SELECT DISTINCT TOP (' + CAST(@MaxLookupRows AS nvarchar(10)) + N') ' +
            N'CONVERT(nvarchar(400), ' + QUOTENAME(@col) + N') AS [value] ' +
            N'FROM ' + QUOTENAME(@sch) + N'.' + QUOTENAME(@tab) + N' ' +
            N'WHERE ' + QUOTENAME(@col) + N' IS NOT NULL ' +
            N'AND LEN(LTRIM(RTRIM(CONVERT(nvarchar(400), ' + QUOTENAME(@col) + N')))) > 0 ' +
            N'ORDER BY 1) v';
        BEGIN TRY
            INSERT INTO #vals (schema_name, table_name, column_name, [value])
            EXEC sys.sp_executesql @dyn, N'@s sysname, @t sysname, @c sysname', @s = @sch, @t = @tab, @c = @col;
        END TRY
        BEGIN CATCH
            PRINT N'Skipped lookup column: ' + @sch + N'.' + @tab + N'.' + @col;
        END CATCH;
        FETCH NEXT FROM cur INTO @sch, @tab, @col;
    END
    CLOSE cur;
    DEALLOCATE cur;

    /* ---- optional manager/responsible lookup (OFF by default) ---- */
    IF @IncludeManagerLookup = 1
    BEGIN
        DECLARE @MgrObj int = OBJECT_ID(QUOTENAME(@MgrRefSchema) + N'.' + QUOTENAME(@MgrRefTable), N'U');
        IF @MgrObj IS NOT NULL AND EXISTS (SELECT 1 FROM #included i WHERE i.oid = @MgrObj)
        BEGIN
            DECLARE @MgrFkCol sysname = (
                SELECT TOP 1 COL_NAME(fkc.parent_object_id, fkc.parent_column_id)
                FROM sys.foreign_keys fk JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
                WHERE fk.parent_object_id = @Root AND fk.referenced_object_id = @MgrObj );
            DECLARE @MgrKeyCol sysname = (
                SELECT TOP 1 COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id)
                FROM sys.foreign_keys fk JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
                WHERE fk.parent_object_id = @Root AND fk.referenced_object_id = @MgrObj );
            DECLARE @MgrDisp sysname = (
                SELECT TOP 1 c.name FROM sys.columns c
                WHERE c.object_id = @MgrObj
                  AND LOWER(c.name) IN (N'displayname', N'fullname', N'name', N'englishname', N'arabicname', N'username')
                  AND EXISTS (SELECT 1 FROM #userallow ua WHERE ua.name = LOWER(c.name))
                  AND NOT EXISTS (SELECT 1 FROM #userforbid uf WHERE LOWER(c.name) LIKE N'%' + uf.term + N'%')
                ORDER BY CASE LOWER(c.name)
                           WHEN N'displayname' THEN 1 WHEN N'fullname' THEN 2 WHEN N'name' THEN 3
                           WHEN N'englishname' THEN 4 WHEN N'arabicname' THEN 5 WHEN N'username' THEN 6 ELSE 9 END );
            IF @MgrFkCol IS NOT NULL AND @MgrKeyCol IS NOT NULL AND @MgrDisp IS NOT NULL
            BEGIN
                DECLARE @mdyn nvarchar(max) =
                    N'SELECT @s AS schema_name, @t AS table_name, @c AS column_name, v.[value], @r AS role FROM (' +
                    N'SELECT DISTINCT TOP (' + CAST(@MaxLookupRows AS nvarchar(10)) + N') ' +
                    N'CONVERT(nvarchar(400), a.' + QUOTENAME(@MgrDisp) + N') AS [value] ' +
                    N'FROM ' + QUOTENAME(@MgrRefSchema) + N'.' + QUOTENAME(@MgrRefTable) + N' a ' +
                    N'JOIN ' + QUOTENAME(@RootSchema) + N'.' + QUOTENAME(@RootTable) + N' p ' +
                    N'ON p.' + QUOTENAME(@MgrFkCol) + N' = a.' + QUOTENAME(@MgrKeyCol) + N' ' +
                    N'WHERE a.' + QUOTENAME(@MgrDisp) + N' IS NOT NULL ' +
                    N'AND LEN(LTRIM(RTRIM(CONVERT(nvarchar(400), a.' + QUOTENAME(@MgrDisp) + N')))) > 0 ' +
                    N'ORDER BY 1) v';
                BEGIN TRY
                    INSERT INTO #vals (schema_name, table_name, column_name, [value], role)
                    EXEC sys.sp_executesql @mdyn,
                        N'@s sysname, @t sysname, @c sysname, @r nvarchar(40)',
                        @s = @MgrRefSchema, @t = @MgrRefTable, @c = @MgrDisp, @r = N'manager_responsible';
                END TRY
                BEGIN CATCH
                    PRINT N'Skipped manager lookup extraction.';
                END CATCH;
            END
        END
    END

    /* ---- lookup_values[] ---- */
    DECLARE @lookupJson nvarchar(max) = ISNULL((
      SELECT
        g.schema_name AS table_schema,
        g.table_name  AS table_name,
        g.column_name AS column_name,
        (SELECT MAX(v3.role) FROM #vals v3
          WHERE v3.schema_name = g.schema_name AND v3.table_name = g.table_name AND v3.column_name = g.column_name) AS reference_role,
        JSON_QUERY(ISNULL((
          SELECT N'[' +
                 STRING_AGG(N'"' + STRING_ESCAPE(v2.[value], 'json') + N'"', N',') WITHIN GROUP (ORDER BY v2.[value]) +
                 N']'
          FROM #vals v2
          WHERE v2.schema_name = g.schema_name AND v2.table_name = g.table_name AND v2.column_name = g.column_name
        ), N'[]')) AS [values]
      FROM (SELECT DISTINCT schema_name, table_name, column_name FROM #vals) g
      ORDER BY g.table_name, g.column_name
      FOR JSON PATH
    ), N'[]');

    /* ---- final assembly ---- */
    DECLARE @json nvarchar(max) =
    (
      SELECT
        @SchemaVer       AS schema_version,
        SYSUTCDATETIME() AS generated_at,
        @RootSchema      AS root_schema,
        @RootTable       AS root_table,
        JSON_QUERY((
          SELECT @DbType AS db_type, @Method AS method, @RootSchema AS root_schema, @RootTable AS root_table
          FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )) AS [source],
        JSON_QUERY((
          SELECT
            @FkDepth            AS fk_depth,
            @MaxLookupRows      AS max_lookup_rows,
            @MaxLookupTableRows AS max_lookup_table_rows,
            CONVERT(bit, 1) AS denylist_applied,
            CONVERT(bit, 0) AS sample_values_enabled,
            @MgrRefTable AS manager_reference_table,
            CONVERT(bit, @IncludeManagerLookup) AS manager_lookup_included,
            JSON_QUERY(ISNULL((
              SELECT e.schema_name AS table_schema, e.table_name AS table_name, e.reason AS reason
              FROM #excluded e ORDER BY e.schema_name, e.table_name FOR JSON PATH
            ), N'[]')) AS excluded_tables
          FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )) AS extraction_summary,
        JSON_QUERY((
          SELECT JSON_QUERY(@tablesJson) AS [tables], JSON_QUERY(@relsJson) AS [relationships]
          FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )) AS schema_metadata,
        JSON_QUERY(@lookupJson) AS lookup_values,
        JSON_QUERY((
          SELECT CONVERT(bit, 0) AS enabled, JSON_QUERY(N'[]') AS [tables]
          FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )) AS sample_values
      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );

    /* Result set 1 */
    SELECT @json AS json_payload, ISJSON(@json) AS is_valid_json, DATALENGTH(@json) / 2 AS total_length;

    /* Result set 2: chunks */
    ;WITH n AS (
      SELECT 1 AS chunk_index, 1 AS startpos
      UNION ALL
      SELECT chunk_index + 1, startpos + @ChunkSize FROM n WHERE startpos + @ChunkSize <= DATALENGTH(@json) / 2
    )
    SELECT
      n.chunk_index,
      SUBSTRING(@json, n.startpos, @ChunkSize) AS chunk_text,
      DATALENGTH(@json) / 2 AS total_length,
      CEILING((DATALENGTH(@json) / 2.0) / @ChunkSize) AS total_chunks
    FROM n
    ORDER BY n.chunk_index
    OPTION (MAXRECURSION 0);
END
GO

EXEC #usp_export_projects_schema;
GO
