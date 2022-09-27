/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 14. Binding Sparse Arrays with INDICES OF
 * ----------------------------------------------------------------------------- 
 * The INDICES OF clause allows you to use sparsely-filled bind arrays in 
 * FORALL. This is necessary because with the "usual" FORALL syntax of:
 * 
 *         FORALL indx IN low_value .. high_value
 * 
 * The PL/SQL engine assumes that every index value between the low and high 
 * values are defined. If any of them are "missing" (not assigned a value), then 
 * you get an error. Not the NO_DATA_FOUND you might expect (which you get when 
 * you try to "read" an element at an undefined index value), but the ORA-22160 
 * error, as you will see when you run the code below.
 */
DECLARE
   TYPE ids_t IS TABLE OF saimk.employees.department_id%TYPE;
   --
   l_ids ids_t := ids_t(10, 50, 100);
BEGIN
   /* Now we remove the "in between" element */
   l_ids.DELETE(2);
   --
   FORALL l_index IN 1 .. l_ids.COUNT
      DELETE 
      FROM saimk.employees t
      WHERE t.department_id = l_ids (l_index)
      ;
   --
   dbms_output.put_line ('#Rows modified = ' || SQL%ROWCOUNT);
   /* 
    * to leave the table in its original state for next examples 
    */
   ROLLBACK;
   --
   EXCEPTION
      WHEN OTHERS THEN       
         dbms_output.put_line ('Rows modified = ' || SQL%ROWCOUNT);
         --         
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('                            SQLERRM -> '||SQLERRM);
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('    DBMS_UTILITY.FORMAT_ERROR_STACK -> '||dbms_utility.format_error_stack);         
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('DBMS_UTILITY.FORMAT_ERROR_BACKTRACE -> '||dbms_utility.format_error_backtrace);
         dbms_output.put_line ('---------------------------------------------');   
         /* 
          * to leave the table in its original state for next examples 
          */         
         ROLLBACK;
END
;
/*
 * How do you get around this problem? Certainly, you could "densify" your 
 * collection before binding it to FORALL. And prior to 10.2 you would have had 
 * to do this. But as of Oracle Database 10g Release 2, you can use INDICES OF 
 * (or VALUES OF - covered in the next module).
 *
 * With the INDICES OF clause, you say, in essence: "Just bind the elements at 
 * the index values that are defined." Or to put it more simply: "Please skip 
 * over any undefined index values." 
 * 
 * Note that the collection referenced in the INDICES OF clause must be indexed 
 * by PLS_INTEGER; you cannot use string-indexed collections. But the datatype 
 * of the elements in the collection can be anything - they are not referenced 
 * at all with INDICES OF.
 */
/*
 * -----------------------------------------------------------------------------
 * EXAMPLE 1:
 * ----------------------------------------------------------------------------- 
 * Let's start with the simplest usage of INDICES OF: the indexing collection is 
 * the same as the bind collection. In the block below, we populate the 
 * l_employees associative array using index values 1, 100, 500 - rather than, 
 * say, 1-3. That's not densely filled!
 *
 * We then use INDICES OF to tell the PL/SQL engine to only use the defined 
 * indices of l_employees, and all is good. This is the simplest form of 
 * INDICES OF: using the bind array in the INDICES OF clause.
 * -----------------------------------------------------------------------------  
 */
DECLARE  
   TYPE employee_aat 
      IS TABLE OF saimk.employees.employee_id%TYPE INDEX BY PLS_INTEGER;  
   --
   l_employees   employee_aat;  
BEGIN  
   l_employees (1) := 137;  
   l_employees (100) := 126;  
   l_employees (500) := 147;  
   --
   FORALL l_index IN INDICES OF l_employees  
      UPDATE saimk.employees t
      SET t.salary = 10000  
      WHERE t.employee_id = l_employees(l_index)
      ;  
   --
   dbms_output.put_line ('#Rows modified = ' || SQL%ROWCOUNT);
   /* 
    * to leave the table in its original state for next examples 
    */   
   ROLLBACK; 
END
;
/*----------------------------------------------------------------------------*/
/*
 * -----------------------------------------------------------------------------
 * EXAMPLE 2:
 * ----------------------------------------------------------------------------- 
 * Here is a more interesting use of INDICES OF: 
 * 
 * We populate a second collection to serve as an "index" into the bind array. 
 * We also include the BETWEEN clause, which can be used to further restrict the 
 * set of elements in the indexing collection that will be used to bind values 
 * into the DML statement. 
 * 
 * It doesn't matter one bit what values are assigned to the elements in the 
 * indexing array - just which index values are defined.
 * ----------------------------------------------------------------------------- 
 */
DECLARE
   TYPE employee_aat 
      IS TABLE OF saimk.employees.employee_id%TYPE INDEX BY PLS_INTEGER;
   --
   l_employees employee_aat;
   --
   TYPE boolean_aat IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;
   --
   l_employee_indices boolean_aat;
BEGIN
   l_employees (1) := 137;
   l_employees (100) := 126;
   l_employees (500) := 147;
   --
   l_employee_indices (1) := FALSE;
   l_employee_indices (500) := TRUE;
   l_employee_indices (799) := NULL;
   --
   FORALL l_index IN INDICES OF l_employee_indices BETWEEN 1 AND 600
      UPDATE saimk.employees t
      SET t.salary = 10001
      WHERE t.employee_id = l_employees (l_index)
      ;
   --
   dbms_output.put_line ('#Rows modified = ' || SQL%ROWCOUNT);
   --
   FOR rec IN (SELECT t.employee_id
               FROM saimk.employees t
               WHERE t.salary = 10001)
   LOOP
      dbms_output.put_line (rec.employee_id);
   END LOOP;
   -- 
   ROLLBACK;
END
;
/*----------------------------------------------------------------------------*/
/* 
 * -----------------------------------------------------------------------------
 * WHEN TO USE AND NOT TO USE INDICES OF?
 * -----------------------------------------------------------------------------
 * You might be thinking to yourself: "Won't INDICES OF work just fine with 
 * densely-filled collections as well? why not use it all time?"
 *
 * Yes, INDICES OF works just fine with dense or sparse collections, and there
 * doesn't seem to be any performance difference. So why not use it all the 
 * time? One thing to consider is that using INDICES OF might hide a bug. What 
 * if your collection really should be dense but something went wrong and now it 
 * has undefined elements? In this case, your code should raise an error but it 
 * will not.
 * 
 * Not good. And that's why we suggest you use the syntax that is appropriate to 
 * your program and context.
 * 
 * A common and most excellent use case for INDICES OF is to help manage bulk 
 * transactions that involve more than one DML statement. For example, you do a 
 * FORALL-UPDATE, then two FORALL-INSERTs. If any of the attempted updates fail, 
 * you need to not perform the associated inserts. One way to do this is to 
 * delete elements from the FORALL-INSERT bind arrays for failed updates. You 
 * will then have a sparse collection and will want to switch to INDICES OF.
 *
 * We do not cover this complex scenario in the tutorial, but this LiveSQL 
 * script shows you the basic idea: Converting from Row-by-Row to 
 * Bulk Processing, http://bit.ly/bulkconv.
 * ----------------------------------------------------------------------------- 
 */
/*
 * -----------------------------------------------------------------------------
 * Exercise 12:
 * -----------------------------------------------------------------------------
 * Change the procedure below so that no assumptions are made about the contents 
 * of the ids_in array and the procedure completes without raising an exception. 
 * Assumptions you could make, but should not, include:
 * 
 * - The collection is never empty.
 * - The first index defined in the collection is 1.
 * - The collection is dense.
 * - The collection is sparse.
    
    CREATE OR REPLACE TYPE numbers_t IS TABLE OF NUMBER
    /
    
    CREATE OR REPLACE PROCEDURE p_update_emps (ids_in IN numbers_t)
    IS
    BEGIN
       FORALL l_index IN 1 .. ids_in.COUNT
          UPDATE saimk.employees t
             SET t.hire_date = SYSDATE
           WHERE t.employee_id = ids_in (l_index);
       --
       ROLLBACK;
    END;
*/    
/*
 * ----------------------------------------------------------------------------- 
 * Solution For Exercise 12:
 * ----------------------------------------------------------------------------- 
 */ 
DECLARE 
  TYPE numbers_t IS TABLE OF NUMBER;
  /* 
   * 'DEFAULT' version of p_run_type doesn't assume the first defined index 
   * value is 1, and it handles empty collections just fine, but it does assume 
   * the collection is densely filled. 
   *
   * 'INDICESOF' version handles all.
   */
  --
  PROCEDURE p_update_emps (ids_in IN numbers_t, p_run_type IN VARCHAR2 DEFAULT 'DEFAULT')
  IS
  BEGIN
    IF p_run_type = 'DEFAULT' THEN
        FORALL l_index IN ids_in.FIRST .. ids_in.LAST
          UPDATE saimk.employees t
          SET t.hire_date = SYSDATE
          WHERE employee_id = ids_in(l_index)
          ;
    ELSIF p_run_type = 'INDICESOF' THEN 
        FORALL l_index IN INDICES OF ids_in
          UPDATE saimk.employees t
          SET t.hire_date = SYSDATE
          WHERE employee_id = ids_in (l_index)
          ;    
    END IF;
    /* 
     * to leave the table in its original state for next examples 
     */  
    ROLLBACK;
  END p_update_emps
  ;
  --
  PROCEDURE p_test_update_emps(p_run_type IN VARCHAR2 DEFAULT 'DEFAULT')
  IS
    l_ids   numbers_t := numbers_t(111, 121, 132);
  BEGIN
     BEGIN
        /* 
         * This is OK: No errors occur whether p_run_type is DEFAULT or 
         * INDICESOF and the bind array is dense or sparse
         */
        p_update_emps (l_ids, p_run_type);
        --
        dbms_output.put_line ('Dense(p_run_type: '||p_run_type||'): Success');
        --
        EXCEPTION
           WHEN OTHERS THEN
              dbms_output.put_line('Dense(p_run_type: '||p_run_type||'): '||SQLERRM);
              --
              ROLLBACK;
     END;
     --
     BEGIN
        /* 
         * This is NOT OK: Error occurs when the bind array is sparse and  
         * p_run_type is DEFAULT
         */      
        l_ids := numbers_t(111, 121, 132);
        l_ids.delete(2);
        --
        p_update_emps (l_ids, p_run_type);
        --
        dbms_output.put_line ('Sparse(p_run_type: '||p_run_type||'): Success');
        --
        EXCEPTION
           WHEN OTHERS THEN
              dbms_output.put_line('Sparse(p_run_type: '||p_run_type||'): '||SQLERRM);
              --
              ROLLBACK;         
     END;
     --
     BEGIN
        /* 
         * This is OK: No errors occur whether p_run_type is DEFAULT or 
         * INDICESOF and the bind array is empty
         */
        l_ids.delete;
        --
        p_update_emps (l_ids, p_run_type);
        --
        dbms_output.put_line ('Empty(p_run_type: '||p_run_type||'): Success');
        --
        EXCEPTION
           WHEN OTHERS THEN
              dbms_output.put_line ('Empty(p_run_type: '||p_run_type||'): '||SQLERRM);
              --
              ROLLBACK;         
     END;
  END p_test_update_emps;
BEGIN
   p_test_update_emps('DEFAULT');
   dbms_output.put_line ('--------------------------------------------------');
   p_test_update_emps('INDICESOF');
END
;
/*----------------------------------------------------------------------------*/
/*
 * -----------------------------------------------------------------------------
 * Exercise 13 (advanced):
 * -----------------------------------------------------------------------------
 * Got some time on your hands? 
 * Ready to explore all that INDICES OF can do? OK, let's go! Write a block of 
 * code that does the following:
 *
 * - Populates a collection using BULK COLLECT with all the rows and columns of 
 *   the employees table, ordered by employee ID: the bind array.
 * 
 * - Declare an associative array that can be used with INDICES OF.
 *
 * - Populate one collection of that type with index values from the bind array 
 *   for all employees with salary = 2600: index array 1.
 *
 * - Populate a second collections of that type with index values from the bind 
 *   array of those employees who were hired in 2004: index array 2.
 *
 * - Write a FORALL statements that uses index array 1 to set the salaries of 
 *   those employees to 2626.
 * 
 * - Write a FORALL statements that uses index array 2 to set the hire dates of 
 *   those employees to January 1 2014.
 *
 * - Include code to verify that the changes were made properly.
 */
/*
 * ----------------------------------------------------------------------------- 
 * Solution For Exercise 13:
 * ----------------------------------------------------------------------------- 
 */ 
DECLARE
   TYPE employee_aat IS TABLE OF saimk.employees%ROWTYPE INDEX BY PLS_INTEGER;
   -- this is for the employees bind array
   l_employees   employee_aat;
   --
   TYPE index_aat IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;
   --
   l_indices1    index_aat;
   l_indices2    index_aat;
BEGIN
   SELECT t.*
   BULK COLLECT 
   INTO l_employees
   FROM saimk.employees t
   ORDER BY t.employee_id
   ;
   --
   dbms_output.put_line ('--------------------------------------------------');
   dbms_output.put_line ('*** Before changes:');
   dbms_output.put_line ('--------------------------------------------------');
   --
   FOR indx IN 1 .. l_employees.COUNT LOOP
      IF l_employees (indx).salary = 2600
      THEN
         l_indices1 (indx) := NULL;
         dbms_output.put_line ('INDEX ' || indx || '---->' || 'EMPLOYEE ID ' || l_employees (indx).employee_id || ' has salary 2600');
      END IF;
      --
      IF TO_CHAR (l_employees (indx).hire_date, 'YYYY') = '2004'
      THEN
         l_indices2 (indx) := NULL;
         dbms_output.put_line ('INDEX ' || indx || '---->' || 'EMPLOYEE ID ' || l_employees (indx).employee_id || ' hired in 2004');
      END IF;
      --
   END LOOP;
   --
   dbms_output.put_line ('--------------------------------------------------');
   --
   FORALL indx IN INDICES OF l_indices1
      UPDATE saimk.employees t
      SET t.salary = 2626
      WHERE t.employee_id = l_employees(indx).employee_id
      ;
   --
   FORALL indx IN INDICES OF l_indices2
      UPDATE saimk.employees t
      SET t.hire_date = TO_DATE ('2014-01-01','YYYY-MM-DD')
      WHERE t.employee_id = l_employees(indx).employee_id
      ;
   --
   dbms_output.put_line ('--------------------------------------------------');
   dbms_output.put_line ('*** After changes:');
   dbms_output.put_line ('--------------------------------------------------');
   --
   FOR rec IN (  SELECT *
                 FROM saimk.employees t
                 ORDER BY t.employee_id
              )
   LOOP
      IF rec.salary = 2626
      THEN
         dbms_output.put_line ('EMPLOYEE ID ' || rec.employee_id || ' has salary 2626');
      END IF;
      --
      IF rec.hire_date = TO_DATE('2014-01-01','YYYY-MM-DD')
      THEN
         dbms_output.put_line ('EMPLOYEE ID ' || rec.employee_id || ' hired 2014-01-01');
      END IF;
   END LOOP;
   --
   dbms_output.put_line ('--------------------------------------------------');
   --
   ROLLBACK;
END
;
/*----------------------------------------------------------------------------*/