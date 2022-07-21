/*
 * Source: https://livesql.oracle.com/apex/f?p=590:1:4704207031745:CLEAR::1:TUTORIAL_ID,P1_SHOW_LEARN_SIDEBAR:182241645422959190146194127811898911783,Y
 * -----------------------------------------------------------------------------
 * SQL%ROWCOUNT and SQL%BULK_ROWCOUNT
 * -----------------------------------------------------------------------------
 * SQL%ROWCOUNT returns the total number of rows modified by the FORALL, 
 * overall. SQL%BULK_ROWCOUNT is a pseudo-collection** that contains one element 
 * for each DML statement executed by FORALL. The element contains the number of 
 * rows modified by that specific DML statement.
 * 
 * In the code below, we write a procedure to update salaries for specified name 
 * filters. Then we show the total number of rows modified. After that, we 
 * iterate through the pseudo-collection to show total number of rows modified
 * for each filter. 
 */
DECLARE
    --
    PROCEDURE update_by_filter (filter_in IN DBMS_SQL.varchar2a)
    IS
    BEGIN
       --
       FORALL indx IN 1 .. filter_in.COUNT
       UPDATE SAIMK.emp
       SET sal = sal * 1.1
       WHERE UPPER (ename) LIKE filter_in (indx);
       --
       DBMS_OUTPUT.put_line ('Total rows modified = ' || SQL%ROWCOUNT);
       --
       FOR indx IN 1 .. filter_in.COUNT
       LOOP
          --
          IF SQL%BULK_ROWCOUNT (indx) = 0
          THEN
             /*raise_application_error (
                -20000,
                'No rows found for filter "' || filter_in (indx) || '"');
              */
              DBMS_OUTPUT.put_line (
                   'THERE ARE NO employees with names like "'
                ||filter_in (indx)
                ||'"');
          --      
          ELSE
             DBMS_OUTPUT.put_line (
                   'Number of employees with names like "'
                || filter_in (indx)
                || '" given a raise: '
                || SQL%BULK_ROWCOUNT (indx));
          END IF;
          --
       END LOOP;
       --
       ROLLBACK;
       --
    END;
    --
BEGIN
   --
   update_by_filter (DBMS_SQL.varchar2a ('S%', 'C%', '%A%','D%'));
   --
END;
