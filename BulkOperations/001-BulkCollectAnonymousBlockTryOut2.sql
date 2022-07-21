/* Bulk CollectOperation Sample With LIMIT*/
--select * from saimk.trashbigdata;
DECLARE
    --
    C_BULK_COLLECT_FETCH_LIMIT CONSTANT NUMBER := 10000;
    --
    t1 TIMESTAMP; 
    t2 TIMESTAMP; 
    t3 TIMESTAMP; 
    t4 TIMESTAMP;
    --
    l_cnt_bulk NUMBER := 0;
    l_cnt_for NUMBER := 0;
    --
    CURSOR C1(cp_country VARCHAR2)
    IS   
    SELECT t.*
    FROM saimk.trashbigdata t
    WHERE (cp_country IS NULL OR t.country = cp_country)
    --AND t.GROUP1 = 1
    --AND t.GROUP2 = 1
    --AND t.GROUP3 = 1
    --AND t.GROUP4 = 1
    ;    
    --
    PROCEDURE show_trashbigdata_bulk (
       pcountry IN saimk.trashbigdata.country%TYPE)
    IS       
       --
       TYPE trashbigdata_info_t IS TABLE OF saimk.trashbigdata%ROWTYPE INDEX BY PLS_INTEGER;
       l_trashbigdata_info   trashbigdata_info_t;
       --    
    BEGIN
        --
        OPEN C1(pcountry);
        --
        LOOP
            --
            FETCH C1
            BULK COLLECT INTO l_trashbigdata_info
            LIMIT C_BULK_COLLECT_FETCH_LIMIT;
            --
            FOR indx IN 1 .. l_trashbigdata_info.COUNT
            LOOP
                --
                l_cnt_bulk := l_cnt_bulk + 1;  
                --
            END LOOP;
            --
            EXIT WHEN l_trashbigdata_info.COUNT = 0;
            --
        END LOOP;
        --
        CLOSE C1;
    END show_trashbigdata_bulk;
    --
    --
    PROCEDURE show_trashbigdata(
       pcountry IN saimk.trashbigdata.country%TYPE)
    IS
    BEGIN
        --
        FOR II IN C1(pcountry)
        LOOP
            --
            l_cnt_for := l_cnt_for + 1;
            --
       END LOOP;
       --
    END show_trashbigdata;
    --
BEGIN
    --
    t1 := systimestamp;
    --
    show_trashbigdata ('Albania'/*NULL*/);
    --
    t2 := systimestamp;
    --
    t3 := systimestamp;
    --
    show_trashbigdata_bulk ('Albania'/*NULL*/);
    --
    t4 := systimestamp;
    --
    DBMS_OUTPUT.PUT_LINE('------------------------------ R E S U L T S ------------------------------');
    DBMS_OUTPUT.PUT_LINE('l_cnt_bulk-->'||l_cnt_bulk);
    DBMS_OUTPUT.PUT_LINE(' l_cnt_for-->'||l_cnt_for);
    --
    DBMS_OUTPUT.PUT_LINE(LPAD('For Loop Cursor Operation Time-->'||SAIMK.f_get_elapsed_time(t1, t2, NULL), 104, ' '));
    DBMS_OUTPUT.PUT_LINE(LPAD('Bulk Collect Operation Time (FETCH LIMIT:'||TO_CHAR(C_BULK_COLLECT_FETCH_LIMIT,'999G999G999G999')||')-->'||SAIMK.f_get_elapsed_time(t3, t4, NULL), 104, ' '));
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------');
    --
END;
/
