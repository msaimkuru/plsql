/*
--------------------------------------------------------------------------------
Source Urls: 
--------------------------------------------------------------------------------
0) https://docs.oracle.com/en/database/oracle/oracle-database/21/cncpt/transactions.html#GUID-A2615547-94D2-4346-B156-64C534C5E9E4
1) https://www.techonthenet.com/oracle/transactions/set_trans.php
2) https://docs.oracle.com/cd/B13789_01/appdev.101/b10807/06_ora.htm#i3316
3) https://www.oreilly.com/library/view/oracle-sql-the/1565926978/1565926978_ch03-86049.html


SET TRANSACTION [ READ ONLY | READ WRITE ]
                [ ISOLATION LEVEL [ SERIALIZE | READ COMMITED ]
                [ USE ROLLBACK SEGMENT 'segment_name' ]
                [ NAME 'transaction_name' ];               
*/     

DECLARE
    /* 
     * This anonymous block begins a transaction and produces and handles an 
     * exception without ending the transaction for purpose of having chance 
     * to query the v$transaction view after the block ends.
     */    
    lv_transaction_name VARCHAR2(1000);
    lv_local_transaction_id VARCHAR2(100);
BEGIN
    COMMIT;  -- end previous transaction   
    --
    /* ------------------------------------------------------------------------- 
     * SET TRANSACTION statement 
     * ------------------------------------------------------------------------- 
     * Establishes the current transaction as read-only or read-write or 
     * specifies the rollback segment to be used by the transaction.
     *
     * You use the SET TRANSACTION statement to begin a read-only or read-write 
     * transaction, establish an isolation level, or assign your current 
     * transaction to a specified rollback segment. Read-only transactions are 
     * useful for running multiple queries while other users update the same 
     * tables.
     *
     * During a read-only transaction, all queries refer to the same snapshot of 
     * the database, providing a multi-table, multi-query, read-consistent view.
     * Other users can continue to query or update data as usual. A commit or 
     * rollback ends the transaction. 
     *
     */
    SET TRANSACTION READ ONLY NAME 'transaction 1';
    
    /* 
     * -------------------------------------------------------------------------
     * DBMS_TRANSACTION.LOCAL_TRANSACTION_ID
     * -------------------------------------------------------------------------
     * This function returns the local (to instance) unique identifier for the 
     * current transaction. It returns null if there is no current transaction.
     */  
    lv_local_transaction_id := DBMS_TRANSACTION.LOCAL_TRANSACTION_ID; 
    dbms_output.put_line('DBMS_TRANSACTION.LOCAL_TRANSACTION_ID-->'||lv_local_transaction_id);
    
    /*
     * Get current transaction name
     */
    SELECT Name
    INTO lv_transaction_name
    FROM v$transaction
    WHERE xidusn ||'.'|| xidslot ||'.'|| xidsqn = lv_local_transaction_id
    ;
    
    /*
     * Get current transaction information
     *
    SELECT x.NAME TRANSACTION_NAME, x.XID as TRANSACTION_ID, 
    x.XIDUSN as UNDO_SEGMENT_NUMBER, x.XIDSLOT as SLOT_NUMBER, x.XIDSQN as SEQUENCE_NUMBER, 
    x.STATUS, x.*
    FROM v$transaction x
    WHERE x.xidusn ||'.'|| x.xidslot ||'.'|| x.xidsqn = DBMS_TRANSACTION.LOCAL_TRANSACTION_ID
    ;     
    */
    
    dbms_output.put_line('lv_transaction_name-->'||lv_transaction_name);
    
    dbms_output.put_line('------------------ 2 EMPLOYEES ------------------');
    
    FOR person IN (SELECT ename FROM emp WHERE ROWNUM < 3) LOOP
        dbms_output.put_line(person.ename);
    END LOOP;
    
    dbms_output.put_line('------------------ 2 DEPARTMENTS ------------------');
    
    FOR dept IN (SELECT dname FROM dept WHERE ROWNUM < 3) LOOP
        dbms_output.put_line(dept.dname);
    END LOOP;
    --
    BEGIN
        INSERT INTO SAIMK.DEPT VALUES (999,'DELETE','DELETE');
    END;
    --
    COMMIT;  -- end read-only transaction
    --
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('-------------------- E R R O R S --------------------');
            dbms_output.put_line('SQLCODE-->'||SQLCODE||', '||'SQLERRM-->'||SQLERRM);
            dbms_output.put_line('-----------------------------------------------------');
            dbms_output.put_line('DBMS_UTILITY.FORMAT_ERROR_STACK:'||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_STACK);
            dbms_output.put_line('-----------------------------------------------------');
            dbms_output.put_line('DBMS_UTILITY.FORMAT_ERROR_BACKTRACE:'||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            dbms_output.put_line('-----------------------------------------------------');
            --dbms_output.put_line(DBMS_UTILITY.FORMAT_CALL_STACK);
            --
            /*
             * ------------
             * Study Note:
             * ------------
             * To end the transaction we must either issue a RAISE or 
             * a ROLLBACK or a COMMIT.
             */
END
;