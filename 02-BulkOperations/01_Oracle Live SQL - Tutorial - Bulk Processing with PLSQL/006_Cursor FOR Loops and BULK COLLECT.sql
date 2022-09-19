/* 
 * Resource: 
 * ---------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 6. Cursor FOR Loops and BULK COLLECT
 * -----------------------------------------------------------------------------
 * When should you convert a non-bulk query to one using BULK COLLECT? 
 * More specifically, should you convert a cursor FOR loop to an explicit cursor 
 * and FETCH BULK COLLECT with limit? Here are some things to keep in mind:
 * 
 * As long as your PL/SQL optimization level is set to 2 (the default) or 
 * higher, the compiler will automatically optimize cursor FOR loops to retrieve 
 * 100 rows with each fetch. You cannot modify this number.
 *
 * If your cursor FOR loop is "read only" (it does not execute non-query DML), 
 * then you can probably leave it as is. That is, fetching 100 rows with each 
 * fetch will usually give you sufficient improvements in performance over 
 * row-by-row fetching.
 *
 * Only cursor FOR loops are optimized this way, so if you have a simple or 
 * WHILE loop that fetches individual rows, you should convert to 
 * BULK COLLECT - with LIMIT!
 * 
 * If you are fetching a very large number of rows, such as might happen with 
 * data warehouse processing or a nightly batch process, then you should 
 * experiment with larger LIMIT values to see what kind of "bang for the buck" 
 * you will get.
 * 
 * If your cursor FOR loop (or any other kind of loop for that matter) contains 
 * one or more non-query DML statements (insert, update, delete, merge), you 
 * should convert to BULK COLLECT and FORALL.
 * 
 * Run the following code to see how optimization affects cursor FOR loop 
 * performance.
 */
/* 
 * ----------------------------------------------------------------------------
 * EXAMPLE 1: Test cursor performance for:
 * -> implicit cursor for loop
 * -> explicit open, fetch, close
 * -> bulk fetch
 * ----------------------------------------------------------------------------
 */ 
CREATE OR REPLACE PROCEDURE p_test_cursor_performance (approach IN VARCHAR2)
IS
  /*
   * @author	Saim Kuru
   * @version 1.0
   * Created for Bulk Processing with PL/SQL Tutorial on 
   * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
   */
   CURSOR cur IS
      SELECT * 
      FROM all_source 
      WHERE ROWNUM < 100001
      ;

   one_row cur%ROWTYPE;

   TYPE t IS TABLE OF cur%ROWTYPE INDEX BY PLS_INTEGER;

   many_rows     t;
   last_timing   NUMBER;
   cntr number := 0;

   PROCEDURE start_timer
   IS
   BEGIN
      last_timing := DBMS_UTILITY.get_cpu_time;
   END start_timer;

   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
            '"'
         || message_in
         || '" completed in: '
         || TO_CHAR (
               ROUND ( (DBMS_UTILITY.get_cpu_time - last_timing) / 100, 2)));
   END show_elapsed_time; 
BEGIN
   start_timer;

   CASE approach
      WHEN 'implicit cursor for loop'
      THEN
         FOR j IN cur
         LOOP
            cntr := cntr + 1;
         END LOOP;

         DBMS_OUTPUT.put_line (cntr);

      WHEN 'explicit open, fetch, close'
      THEN
         OPEN cur;
         --
         LOOP
            FETCH cur 
            INTO one_row;
            EXIT WHEN cur%NOTFOUND;
            cntr := cntr + 1;
         END LOOP;
         --
         DBMS_OUTPUT.put_line (cntr);
         --
         CLOSE cur;
      WHEN 'bulk fetch'
      THEN
         OPEN cur;
         --
         LOOP
            FETCH cur 
            BULK COLLECT 
            INTO many_rows 
            LIMIT 100
            ;
            --
            EXIT WHEN many_rows.COUNT = 0;
            --
            FOR indx IN 1 .. many_rows.COUNT
            LOOP
               cntr := cntr + 1;
            END LOOP;
         END LOOP;
         --
         DBMS_OUTPUT.put_line (cntr);
         --
         CLOSE cur;
   END CASE;

   show_elapsed_time (approach);
END p_test_cursor_performance
;

/* 
 * Try different approaches with optimization disabled. 
 */
ALTER PROCEDURE p_test_cursor_performance
COMPILE plsql_optimize_level=0
;

BEGIN
   dbms_output.put_line ('No optimization...');
   
   p_test_cursor_performance ('implicit cursor for loop');

   p_test_cursor_performance ('explicit open, fetch, close');

   p_test_cursor_performance ('bulk fetch');
END
;
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
 
/* 
 * Try different approaches with default optimization. 
 */
ALTER PROCEDURE p_test_cursor_performance
COMPILE plsql_optimize_level=2
;

BEGIN
   DBMS_OUTPUT.put_line ('Default optimization...');

   p_test_cursor_performance ('implicit cursor for loop');

   p_test_cursor_performance ('explicit open, fetch, close');

   p_test_cursor_performance ('bulk fetch');
END
;

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

/*
 * -----------------------------------------------------------------------------
 * Exercise 3
 * ----------------------------------------------------------------------------- 
 * This exercise has two parts (and for this exercise assume that the employees 
 * table has 1M rows with data distributed equally amongst departments: 
 * (1) Write an anonymous block that contains a cursor FOR loop that does not 
 * need to be converted to using BULK COLLECT. 
 * (2) Write an anonymous block that contains a cursor FOR loop that does need
 * to use BULK COLLECT (assume it cannot be rewritten in "pure" SQL).
 * ----------------------------------------------------------------------------- 
 * Solution For Exercise 3
 * -----------------------------------------------------------------------------  
 */
/*
 * Solution for Exercise 3 Part 1
 */
BEGIN
   /* There is no need to convert to bulk collect because the PL/SQL
      compiler will automatically optimize the CFL to run "like" a
      BULK COLLECT with limit set to 100. */
   FOR rec IN (SELECT *
                 FROM employees
                WHERE department_id = 50)
   LOOP
      DBMS_OUTPUT.put_line (rec.last_name || ' - ' || rec.salary);
   END LOOP;
END
;
/*
 * Solution for Exercise 3 Part 2
 */
BEGIN
   /* This loop now has a non-query DML statement inside it. And lots
      of employees in each department. So this row by row update is
      going to be slow. The compiler will still optimize the cursor FOR
      loop to be like a BULK COLLECT, but the row-by-row update will
      still be slow. 

      Bottom line: loop with non-query DML must be converted to
      "pure" SQL or a BULK COLLECT - FORALL combo! */
   FOR rec IN (SELECT employee_id
                 FROM employees
                WHERE department_id = 50)
   LOOP
      UPDATE employees
         SET salary = salary * 1.1
       WHERE employee_id = rec.employee_id;
   END LOOP;
END
;
