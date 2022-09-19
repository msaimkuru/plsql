/*
 * -----------------------------------------------------------------------------
 * Subject:
 * -----------------------------------------------------------------------------
 * 1) Performance testing and comparing between;
 *  - explicit open cursor, fetch, loop row-by-row update
 *  - explicit open cursor, bulk fetch limit, loop forall update
 * 
 * 2) Use of 'ALTER SYSTEM FLUSH BUFFER_CACHE': In Oracle 10g and beyond, 
 * this command will flush the buffer cache
 * -----------------------------------------------------------------------------
 */
DECLARE
    --
    INVALID_CASE_ERROR EXCEPTION;
    PRAGMA EXCEPTION_INIT(INVALID_CASE_ERROR, -6592);
    --
    l_t1 TIMESTAMP;
    l_t2 TIMESTAMP;
    last_timing NUMBER;   
    --
    l_loop_count NUMBER;
    l_row_cnt NUMBER;
    --
    C_FETCH_AND_PROCESS_ROWBYROW CONSTANT VARCHAR2(100) := 'explicit open, fetch, loop update';
    C_BULKFETCH_BY_LIMIT_AND_PROCESS CONSTANT VARCHAR2(100) := 'bulk fetch limit loop-forall update';
    --
    PROCEDURE testPerformance(p_approach VARCHAR2, p_bulk_collect_fetch_limit NUMBER, p_query_no NUMBER, p_loop_count IN OUT NUMBER, p_row_cnt IN OUT NUMBER)
    IS
        --
        TYPE t_c1 IS REF CURSOR;
        C1 t_c1;
        --    
        TYPE t_rec IS RECORD(
            id saimk.trashbigdata.id%TYPE,
            country saimk.trashbigdata.country%TYPE
        );
        --
        l_rec_c1 t_rec;
        --
        TYPE t_bigdata IS TABLE OF t_rec INDEX BY PLS_INTEGER;
        bigdata_t t_bigdata;
        --         
    BEGIN
        --
        p_loop_count := 0;
        p_row_cnt := 0;
        --
        CASE p_query_no
        WHEN 1 THEN
            OPEN c1 FOR '
            SELECT t.id, t.country 
            FROM saimk.trashbigdata t
            WHERE 1=1
            AND t.country IN(''Albania'', ''Algeria'', ''American Samoa'', ''Andorra'', ''Angola'', ''Anguilla'', ''Antarctica'', ''Argentina'', ''Australia'', ''Austria'')
            AND t.group1 = 1 AND t.group2 = 1 AND t.group3 = 1 AND t.group4 = 1 AND t.group5 = 1'
            ;
        WHEN 2 THEN
            OPEN c1 FOR '
            SELECT t.id, t.country 
            FROM saimk.trashbigdata t
            WHERE 1=1
            AND t.country IN(''Albania'', ''Algeria'', ''American Samoa'', ''Andorra'', ''Angola'', ''Anguilla'', ''Antarctica'', ''Argentina'', ''Australia'', ''Austria'')
            AND t.group1 = 1 AND t.group2 = 1 AND t.group3 = 1'
            ;
        WHEN 3 THEN
            OPEN c1 FOR '
            SELECT t.id, t.country 
            FROM saimk.trashbigdata t
            WHERE 1=1
            AND t.country IN(''Albania'', ''Algeria'', ''American Samoa'', ''Andorra'', ''Angola'', ''Anguilla'', ''Antarctica'', ''Argentina'', ''Australia'', ''Austria'')
            AND t.group1 = 1'
            ;
        WHEN 4 THEN
            OPEN c1 FOR '
            SELECT t.id, t.country 
            FROM saimk.trashbigdata t
            WHERE 1=1
            AND t.country IN(''Albania'', ''Algeria'', ''American Samoa'', ''Andorra'', ''Angola'', ''Anguilla'', ''Antarctica'', ''Argentina'', ''Australia'', ''Austria'')'
            ;            
        WHEN 5 THEN
            OPEN c1 FOR '
            SELECT t.id, t.country 
            FROM saimk.trashbigdata t'
            ;
        ELSE
            RAISE INVALID_CASE_ERROR;
        END CASE;    
        --
        LOOP
            --
            IF p_approach = C_FETCH_AND_PROCESS_ROWBYROW THEN
                --
                FETCH c1 INTO l_rec_c1;
                --
                EXIT WHEN c1%NOTFOUND;
                --
                p_loop_count := p_loop_count + 1;
                --
                UPDATE saimk.trashbigdata t
                SET t.additional_data = 'X'
                WHERE t.id = l_rec_c1.id
                AND t.country = l_rec_c1.country      
                ;
                --
                p_row_cnt := p_row_cnt + SQL%ROWCOUNT;
                --
            ELSIF p_approach = C_BULKFETCH_BY_LIMIT_AND_PROCESS THEN
                --
                FETCH c1 BULK COLLECT INTO bigdata_t LIMIT p_bulk_collect_fetch_limit;
                --
                EXIT WHEN bigdata_t.COUNT = 0;
                --
                p_loop_count := p_loop_count + 1;
                --
                FORALL indx IN 1..bigdata_t.COUNT
                UPDATE saimk.trashbigdata t
                SET t.additional_data = 'X'
                WHERE t.id = bigdata_t(indx).id
                AND t.country = bigdata_t(indx).country      
                ;
                --
                p_row_cnt := p_row_cnt + SQL%ROWCOUNT;
                --           
            END IF;
            --
        END LOOP;
        --
        CLOSE c1;
        --
        COMMIT;
        --
        EXCEPTION
            WHEN OTHERS THEN
                IF c1%ISOPEN THEN
                    CLOSE c1;
                END IF;
                --
                ROLLBACK;
                --
                RAISE;
                --
    END testPerformance;
    --
    --
    PROCEDURE start_timer
    IS
    BEGIN
      --
      last_timing := DBMS_UTILITY.get_cpu_time;
      --
    END start_timer;
    --
    --
    PROCEDURE invokeTestPerformance(p_approach VARCHAR2, p_bulk_collect_fetch_limit NUMBER, p_query_no NUMBER, p_loop_count IN OUT NUMBER, p_row_cnt IN OUT NUMBER)
    IS
    BEGIN
        --In Oracle 10g and beyond, this command will flush the buffer cache: 
        EXECUTE IMMEDIATE 'ALTER SYSTEM FLUSH BUFFER_CACHE';   
        --
        start_timer;
        --
        l_t1 := systimestamp;
        --
        testPerformance(p_approach, p_bulk_collect_fetch_limit, p_query_no, p_loop_count, p_row_cnt);
        --
        l_t2 := systimestamp;
        --
        DBMS_OUTPUT.PUT_LINE  ('---------------------------------------- Output for: '
                             ||p_approach
                             ||(CASE WHEN p_approach = 'bulk fetch limit loop-forall update' THEN '(FETCH LIMIT:'||p_bulk_collect_fetch_limit||')'END)
                             ||'(p_query_no-->'||p_query_no||')'
                             ||'----------------------------------------'
        );
        DBMS_OUTPUT.PUT_LINE(RPAD('p_loop_count', 40, ' ')
                             ||RPAD('Elapsed cpu time(seconds)', 40, ' ')
                             ||RPAD('Elapsed time:', 40, ' ')
                             ||RPAD('#Rows Update:', 40, ' ')
                             );
        DBMS_OUTPUT.PUT_LINE(RPAD(p_loop_count, 40, ' ')
                             ||RPAD(saimk.f_get_elapsed_cpu_time(last_timing, NULL), 40, ' ')
                             ||RPAD(saimk.f_get_elapsed_time(l_t1, l_t2, NULL), 40, ' ')
                             ||RPAD(p_row_cnt, 40, ' ')
                             ); 
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------');               
        --
    END;
    --
BEGIN
    FOR II IN 1..5 LOOP
        --
        DBMS_OUTPUT.PUT_LINE('**************************************************** Experimented Query No -> '||II||'**********************************************************************');
        --
        invokeTestPerformance(C_FETCH_AND_PROCESS_ROWBYROW, 10000, II, l_loop_count, l_row_cnt);
        --
        invokeTestPerformance(C_BULKFETCH_BY_LIMIT_AND_PROCESS, 10000, II, l_loop_count, l_row_cnt);
        --
        invokeTestPerformance(C_BULKFETCH_BY_LIMIT_AND_PROCESS, 100000, II, l_loop_count, l_row_cnt);
        --
        invokeTestPerformance(C_BULKFETCH_BY_LIMIT_AND_PROCESS, 200000, II, l_loop_count, l_row_cnt);
        --
        invokeTestPerformance(C_BULKFETCH_BY_LIMIT_AND_PROCESS, 1000000, II, l_loop_count, l_row_cnt);
        --
        DBMS_OUTPUT.PUT_LINE('*****************************************************************************************************************************************************');
        --
    END LOOP;        
END;

/*
 * SAMPLE OUTPUT:
**************************************************** Experimented Query No -> 1**********************************************************************
---------------------------------------- Output for: explicit open, fetch, loop update(p_query_no-->1)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
500                                     2,09                                    +000000 00:00:06.248000000              500                                     
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:10000)(p_query_no-->1)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
1                                       3,94                                    +000000 00:00:05.888000000              500                                     
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:100000)(p_query_no-->1)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
1                                       2,39                                    +000000 00:00:06.162000000              500                                     
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:200000)(p_query_no-->1)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
1                                       2,2                                     +000000 00:00:06.158000000              500                                     
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:1000000)(p_query_no-->1)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
1                                       2,6                                     +000000 00:00:06.159000000              500                                     
---------------------------------------------------------------------------------------------
*****************************************************************************************************************************************************
**************************************************** Experimented Query No -> 2**********************************************************************
---------------------------------------- Output for: explicit open, fetch, loop update(p_query_no-->2)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
50000                                   3,13                                    +000000 00:00:11.801000000              50000                                   
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:10000)(p_query_no-->2)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
5                                       2,96                                    +000000 00:00:09.584000000              50000                                   
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:100000)(p_query_no-->2)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
1                                       3,19                                    +000000 00:00:09.551000000              50000                                   
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:200000)(p_query_no-->2)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
1                                       3,08                                    +000000 00:00:09.683000000              50000                                   
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:1000000)(p_query_no-->2)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
1                                       2,82                                    +000000 00:00:09.647000000              50000                                   
---------------------------------------------------------------------------------------------
*****************************************************************************************************************************************************
**************************************************** Experimented Query No -> 3**********************************************************************
---------------------------------------- Output for: explicit open, fetch, loop update(p_query_no-->3)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
1000000                                 44,53                                   +000000 00:03:01.610000000              1000000                                 
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:10000)(p_query_no-->3)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
100                                     10,76                                   +000000 00:02:49.109000000              1000000                                 
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:100000)(p_query_no-->3)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
10                                      11,41                                   +000000 00:02:57.130000000              1000000                                 
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:200000)(p_query_no-->3)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
5                                       11,36                                   +000000 00:02:41.622000000              1000000                                 
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:1000000)(p_query_no-->3)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
1                                       11,3                                    +000000 00:02:41.326000000              1000000                                 
---------------------------------------------------------------------------------------------
*****************************************************************************************************************************************************
**************************************************** Experimented Query No -> 4**********************************************************************
---------------------------------------- Output for: explicit open, fetch, loop update(p_query_no-->4)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
5000000                                 21,4                                    +000000 00:02:19.196000000              5000000                                 
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:10000)(p_query_no-->4)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
500                                     14,53                                   +000000 00:01:05.532000000              5000000                                 
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:100000)(p_query_no-->4)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
50                                      14,19                                   +000000 00:01:05.308000000              5000000                                 
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:200000)(p_query_no-->4)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
25                                      14,05                                   +000000 00:01:05.202000000              5000000                                 
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:1000000)(p_query_no-->4)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
5                                       15,45                                   +000000 00:01:13.072000000              5000000                                 
---------------------------------------------------------------------------------------------
*****************************************************************************************************************************************************
**************************************************** Experimented Query No -> 5**********************************************************************
---------------------------------------- Output for: explicit open, fetch, loop update(p_query_no-->5)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
124500000                               1941                                    +000000 00:39:18.320000000              124500000                               
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:10000)(p_query_no-->5)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
12450                                   306,11                                  +000000 00:13:30.028000000              124500000                               
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:100000)(p_query_no-->5)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
1245                                    321,52                                  +000000 00:14:01.274000000              124500000                               
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:200000)(p_query_no-->5)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
623                                     317,03                                  +000000 00:13:56.637000000              124500000                               
---------------------------------------------------------------------------------------------
---------------------------------------- Output for: bulk fetch limit loop-forall update(FETCH LIMIT:1000000)(p_query_no-->5)----------------------------------------
p_loop_count                            Elapsed cpu time(seconds)               Elapsed time:                           #Rows Update:                           
125                                     326,19                                  +000000 00:14:03.517000000              124500000                               
---------------------------------------------------------------------------------------------
*****************************************************************************************************************************************************
*/