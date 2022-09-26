/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 10. SQL%ROWCOUNT, SQL%BULK_ROWCOUNT and Pseudo-Collection
 * ----------------------------------------------------------------------------- 
 * SQL%ROWCOUNT returns the total number of rows modified by the FORALL, 
 * overall. SQL%BULK_ROWCOUNT is a pseudo-collection** that contains one element
 * for each DML statement executed by FORALL. The element contains the number of 
 * rows modified by that specific DML statement.
 */
/*
 * -----------------------------------------------------------------------------
 * EXAMPLE 1:
 * -----------------------------------------------------------------------------
 * In the code below, we code a procedure to update salaries for specified 
 * name filters. Then we show the total number of rows modified. After that, we 
 * iterate through the pseudo-collection to show total number of rows modified. 
 * 
 * In addition, we apply a quality assurance check: the rule for this code is 
 * that if any filter does not change any rows, then we raise an exception. This 
 * is just one way that you might want to use SQL%BULK_ROWCOUNT.
 * ----------------------------------------------------------------------------- 
 */
DECLARE 
  TYPE filter_nt IS TABLE OF VARCHAR2(100);
  --
  PROCEDURE p_update_by_filter(filter_in IN filter_nt)
  IS
  BEGIN
    FORALL indx IN 1 .. filter_in.COUNT
      UPDATE saimk.employees t
      SET t.salary = t.salary * 1.1
      WHERE UPPER (t.last_name) LIKE filter_in(indx)
      ;
    --
    dbms_output.put_line('--------------------------------------------------');
    dbms_output.put_line('#Total rows modified = ' || SQL%ROWCOUNT);
    dbms_output.put_line('--------------------------------------------------');
    --
    FOR indx IN 1 .. filter_in.COUNT LOOP
      IF SQL%BULK_ROWCOUNT (indx) = 0
      THEN
         dbms_output.put_line('BUSINESS ERROR: ' || 'No rows found for filter "' || filter_in (indx) || '"');
         dbms_output.put_line('----------');
         raise_application_error (
            -20000,
            'No rows found for filter "' || filter_in (indx) || '"');
      ELSE
         dbms_output.put_line (
               'Number of employees with names like "'
            || filter_in (indx)
            || '" given a raise: '
            || SQL%BULK_ROWCOUNT(indx));
      END IF;
      --
      dbms_output.put_line('----------');
    END LOOP;
   /* 
    * to leave the table in its original state for next examples 
    */ 
    ROLLBACK;
    --
    EXCEPTION
      WHEN OTHERS THEN
       /* 
        * to leave the table in its original state for next examples 
        */ 
        ROLLBACK;
        --
        RAISE;
  END p_update_by_filter;
BEGIN
   p_update_by_filter (filter_nt ('S%', 'E%', '%A%'));
   /*
    * And now with a filter that finds no employees.
    */
   p_update_by_filter (filter_nt ('S%', 'E%', '%A%', 'XXXXX'));
END
;
/*----------------------------------------------------------------------------*/
/*
 * ** What's a "pseudo-collection"? It's a data structure created implicitly by 
 * PL/SQL for us. The "pseudo" indicates that it doesn't have all the features
 * of a "normal" collection.
 * 
 * In the case of SQL%BULK_ROWCOUNT, it has no methods defined on it 
 * (COUNT, FIRST, LAST, etc.). It always has the same index values defined in it 
 * as the bind array, regardless of whether it is densely or sparsely filled.
 */
/*----------------------------------------------------------------------------*/ 
/*
 * -----------------------------------------------------------------------------
 * Exercise 8
 * -----------------------------------------------------------------------------
 * Write the rest of the procedure whose signature is shown below. 
 *
     PROCEDURE p_update_salaries (
       p_department_ids_in IN dbms_sql.number_table,
       p_salaries_in IN dbms_sql.number_table)
 *
 * The procedure uses FORALL to update the salaries of all employees 
 * in each department to the corresponding value in the salaries array. 
 * Afterwards, display the total number of rows modified. 
 * Raise the PROGRAM_ERROR exception if any of the update statements 
 * (for a specific department ID) change less than 2 rows.
 */
/* 
 * ----------------------------------------------------------------------------- 
 * Solution For Exercise 8
 * ----------------------------------------------------------------------------- 
 */
DECLARE
    l_deps dbms_sql.number_table := dbms_sql.number_table(30, 20, 10);
    l_sals dbms_sql.number_table := dbms_sql.number_table(3000, 1000, 2000);
    --
    PROCEDURE p_update_salaries (
         p_department_ids_in IN dbms_sql.number_table,
         p_salaries_in IN dbms_sql.number_table
    )
    IS
    BEGIN
      FORALL l_indx IN 1..p_department_ids_in.COUNT
        UPDATE saimk.employees t
        SET t.salary = p_salaries_in(l_indx)
        WHERE t.department_id = p_department_ids_in(l_indx)
        ;
      --
      dbms_output.put_line('#Total Rows updated:' || SQL%ROWCOUNT);
      --
      FOR l_indx IN 1..p_department_ids_in.COUNT LOOP
        dbms_output.put_line('#Rows updated for department id ' || p_department_ids_in(l_indx) || ':' || SQL%BULK_ROWCOUNT(l_indx));
        --
        IF SQL%BULK_ROWCOUNT(l_indx) < 2 THEN
          /* 
           * to leave the table in its original state for next examples 
           */        
          ROLLBACK;
          RAISE PROGRAM_ERROR;
        END IF;
      END LOOP;
      /* 
       * to leave the table in its original state for next examples 
       */
      ROLLBACK;
      --
      EXCEPTION
        WHEN OTHERS THEN
          /* 
           * to leave the table in its original state for next examples 
           */
          ROLLBACK;  
          --
          RAISE;
    END p_update_salaries
    ;
BEGIN
  p_update_salaries(l_deps, l_sals);
END
;
/*----------------------------------------------------------------------------*/