SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

/* Commented so I can run the big select without selecting text.
command will tell what reporting sproc may be running. can be modified to see anything that is running.

DBCC INPUTBUFFER(xxx)

*/

      SELECT DB_NAME(st.dbid) AS [Database]
            ,CONVERT(varchar(24), r.Start_time, 20) AS StartTime
            ,r.wait_time
            ,r.cpu_time
            ,CONVERT(decimal(9, 1), (r.granted_query_memory/128.0)) AS MBytesRAM
            ,ss.login_name
            ,SUBSTRING(st.text, (r.statement_start_offset/2)+1, 
            ((CASE r.statement_end_offset
               WHEN -1 THEN DATALENGTH(st.text)
               ELSE r.statement_end_offset
            END - r.statement_start_offset)/2) + 1) AS CurrentStatement
       FROM sys.dm_exec_connections c
       JOIN sys.dm_exec_sessions ss ON c.session_id = ss.session_id
       JOIN sys.dm_exec_requests r ON ss.session_id = r.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) st 
      WHERE r.session_id > 45
        AND r.session_id <> @@SPID
        --and (ss.[host_name] like '%RPT%' OR ss.[host_name] Like '%sltelt%' OR ss.[host_name] like '%SLOT%' OR ss.[host_name] like '%sltdelt%' OR ss.[host_name] LIKE '%sltde%' OR ss.[host_name] like '%sltx%' OR ss.login_name = 'CT\brazumich')\
        --and ISNULL(OBJECT_NAME(st.objectid, st.dbid), 'Ad hoc') = 'TriggeredSubscribersWithEventsById'
   ORDER BY r.start_time
