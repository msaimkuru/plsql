/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 6. Cursor FOR Loops and BULK COLLECT 
 *    -- When should you convert a non-bulk query to one using BULK COLLECT? --
 * -----------------------------------------------------------------------------
 * When should you convert a non-bulk query to one using BULK COLLECT? 
 * More specifically, should you convert a cursor FOR loop to an explicit cursor 
 * and FETCH BULK COLLECT with limit? Here are some things to keep in mind:
 * 
 * 1) As long as your PL/SQL optimization level is set to 2 (the default) or 
 * higher, the compiler will automatically optimize cursor FOR loops to retrieve 
 * 100 rows with each fetch. You cannot modify this number.
 *
 * 2) If your cursor FOR loop is "read only" (it does not execute non-query DML), 
 * then you can probably leave it as is. That is, fetching 100 rows with each 
 * fetch will usually give you sufficient improvements in performance over 
 * row-by-row fetching.
 *
 * 3) Only cursor FOR loops are optimized this way, so if you have a simple or 
 * WHILE loop that fetches individual rows, you should convert to 
 * BULK COLLECT - with LIMIT!
 * 
 * 4) If you are fetching a very large number of rows, such as might happen with 
 * data warehouse processing or a nightly batch process, then you should 
 * experiment with larger LIMIT values to see what kind of "bang for the buck" 
 * you will get.
 * 
 * 5) If your cursor FOR loop (or any other kind of loop for that matter) 
 * contains one or more non-query DML statements (insert, update, delete, 
 * merge), you should convert to BULK COLLECT and FORALL.
 * 
 * -----------------------------------------------------------------------------
 * Notes:
 * ----------------------------------------------------------------------------- 
 * Resource: https://buildmedia.readthedocs.org/media/pdf/oracle/latest/oracle.pdf
 * -----------------------------------------------------------------------------
 * PL/SQL optimizer: Since Oracle Database 10g the PL/SQL compiler can optimize 
 * PL/SQL code before it is translated to system code. The optimizer setting
 * PLSQL_OPTIMIZE_LEVEL — 0, 1, 2 (default), or 3 — determines the level of 
 * optimization. The higher the value, the more time it takes to compile 
 * objects, although the difference is usually hardly noticeable and worth the 
 * extra time.
 *
 * To see the current value of the PLSQL_OPTIMIZE_LEVEL parameter we can issue
 * the query below:
 *
        SELECT t.* 
        FROM V$PARAMETER t 
        WHERE UPPER(t.name) = 'PLSQL_OPTIMIZE_LEVEL'
        ;
 * ----------------------------------------------------------------------------- 
 */
/* 
 * ----------------------------------------------------------------------------
 * EXAMPLE 1: 
 * ---------------------------------------------------------------------------- 
 * Run the following code to see how optimization affects cursor FOR loop 
 * performance.
 *
 * Test cursor performance for:
 * -> implicit cursor for loop
 * -> explicit open, fetch, close
 * -> bulk fetch
 * ----------------------------------------------------------------------------
 */ 
CREATE OR REPLACE PROCEDURE saimk.p_test_cursor_performance(p_approach IN VARCHAR2)
IS
   /*
    * @author	Saim Kuru
    * @version 1.0
    * Created for Bulk Processing with PL/SQL Tutorial on 
    * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
    */
   CURSOR cur 
   IS
   SELECT t.* 
   FROM all_source t
   WHERE ROWNUM < 100001
   ;
   --
   l_one_row cur%ROWTYPE;
   --
   TYPE tbl_t IS TABLE OF cur%ROWTYPE INDEX BY PLS_INTEGER;
   --
   l_many_rows tbl_t;
   --
   l_last_timing NUMBER;
   l_cntr NUMBER := 0;
   --
   PROCEDURE p_start_timer
   IS
   BEGIN
      l_last_timing := dbms_utility.get_cpu_time;
   END p_start_timer;
   --
   PROCEDURE p_show_elapsed_time(message_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      dbms_output.put_line(
            '"'
         || message_in
         || '" completed in: '
         || TO_CHAR(ROUND((dbms_utility.get_cpu_time - l_last_timing) / 100, 2
                         )
                   )
       );
   END p_show_elapsed_time; 
BEGIN
   p_start_timer;
   --
   CASE p_approach
      WHEN 'implicit cursor for loop' THEN
         FOR j IN cur
         LOOP
            l_cntr := l_cntr + 1;
         END LOOP;
         --
         dbms_output.put_line(l_cntr);
         --
      WHEN 'explicit open, fetch, close' THEN
         OPEN cur;
         --
         LOOP
            FETCH cur 
            INTO l_one_row
            ;
            --
            EXIT WHEN cur%NOTFOUND;
            --
            l_cntr := l_cntr + 1;
         END LOOP;
         --
         dbms_output.put_line(l_cntr);
         --
         CLOSE cur;
      WHEN 'bulk fetch' THEN
         OPEN cur;
         --
         LOOP
            FETCH cur 
            BULK COLLECT 
            INTO l_many_rows 
            LIMIT 100
            ;
            --
            EXIT WHEN l_many_rows.COUNT = 0;
            --
            FOR indx IN 1 .. l_many_rows.COUNT
            LOOP
               l_cntr := l_cntr + 1;
            END LOOP;
         END LOOP;
         --
         dbms_output.put_line(l_cntr);
         --
         CLOSE cur;
   END CASE;
   --
   p_show_elapsed_time (p_approach);
   --
END p_test_cursor_performance;
/*----------------------------------------------------------------------------*/
/* 
 * Try different approaches with optimization disabled. 
 */
ALTER PROCEDURE saimk.p_test_cursor_performance
COMPILE plsql_optimize_level=0
;
--
BEGIN
   dbms_output.put_line ('No optimization...');
   --
   saimk.p_test_cursor_performance ('implicit cursor for loop');
   --
   saimk.p_test_cursor_performance ('explicit open, fetch, close');
   --
   saimk.p_test_cursor_performance ('bulk fetch');
END;
/*
 * ----------------------------------------------------------------------------- 
 * OUTPUT
 * ----------------------------------------------------------------------------- 
    No optimization...
    100000
    "implicit cursor for loop" completed in: ,55
    100000
    "explicit open, fetch, close" completed in: ,48
    100000
    "bulk fetch" completed in: ,28 
 * ----------------------------------------------------------------------------- 
 */
/*----------------------------------------------------------------------------*/ 
/* 
 * Try different approaches with default optimization. 
 */
ALTER PROCEDURE saimk.p_test_cursor_performance
COMPILE plsql_optimize_level=2
;
--
BEGIN
   dbms_output.put_line ('Default optimization...');
   --
   saimk.p_test_cursor_performance ('implicit cursor for loop');
   --
   saimk.p_test_cursor_performance ('explicit open, fetch, close');
   --
   saimk.p_test_cursor_performance ('bulk fetch');
END;
/*
 * ----------------------------------------------------------------------------- 
 * OUTPUT
 * ----------------------------------------------------------------------------- 
    Default optimization...
    100000
    "implicit cursor for loop" completed in: ,3
    100000
    "explicit open, fetch, close" completed in: ,48
    100000
    "bulk fetch" completed in: ,28

 * ----------------------------------------------------------------------------- 
 */
/*----------------------------------------------------------------------------*/
/*
 * -----------------------------------------------------------------------------
 * Exercise 3
 * ----------------------------------------------------------------------------- 
 * This exercise has two parts (and for this exercise assume that the employees 
 * table has 1M rows with data distributed equally amongst departments: 
 *
 * (1) Write an anonymous block that contains a cursor FOR loop that does not 
 * need to be converted to using BULK COLLECT. 
 *
 * (2) Write an anonymous block that contains a cursor FOR loop that does need
 * to use BULK COLLECT (assume it cannot be rewritten in "pure" SQL).
 */
/*
 * ----------------------------------------------------------------------------- 
 * Solutions For Exercise 3
 * -----------------------------------------------------------------------------  
 */ 
/*
 * Solution for Exercise 3 Part 1
 */
BEGIN
   /* 
    * There is no need to convert to bulk collect because the PL/SQL
    * compiler will automatically optimize the CFL to run "like" a
    * BULK COLLECT with limit set to 100. 
    */
   FOR rec IN (SELECT t.*
                 FROM saimk.employees t
                WHERE t.department_id = 50
              )
   LOOP
      dbms_output.put_line (rec.last_name || ' - ' || rec.salary);
   END LOOP;
END;
/*
 * Solution for Exercise 3 Part 2
 */
BEGIN
   /* 
    * This loop now has a non-query DML statement inside it. And lots
    * of employees in each department. So this row by row update is
    * going to be slow. The compiler will still optimize the cursor FOR
    * loop to be like a BULK COLLECT, but the row-by-row update will
    * still be slow. 
    *
    * Bottom line: loop with non-query DML must be converted to
    *  "pure" SQL or a BULK COLLECT - FORALL combo! 
    */
   FOR rec IN (SELECT t.employee_id
                 FROM saimk.employees t
                WHERE t.department_id = 50
              )
   LOOP
      UPDATE saimk.employees t
      SET t.salary = t.salary * 1.1
      WHERE t.employee_id = rec.employee_id
      ; 
   END LOOP;
   /* 
    * to leave the table in its original state for next examples 
    */
   ROLLBACK;
END;
/*----------------------------------------------------------------------------*/