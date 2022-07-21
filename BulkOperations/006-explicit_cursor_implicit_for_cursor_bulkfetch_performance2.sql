/*
 * -----------------------------------------------------------------------------
 * Cursor FOR Loops and BULK COLLECT
 * -----------------------------------------------------------------------------
 * When should you convert a non-bulk query to one using BULK COLLECT? 
 * 
 * More specifically, should you convert a cursor FOR loop to an explicit cursor 
 * and FETCH BULK COLLECT with limit? Here are some things to keep in mind:
 * 
 * 1) As long as your PL/SQL optimization level is set to 2 (the default) or
 * higher, the compiler will automatically optimize cursor FOR loops to retrieve 
 * 100 rows with each fetch. You cannot modify this number.
 * 
 * 2)If your cursor FOR loop is "read only" (it does not execute non-query DML), 
 * then you can probably leave it as is. That is, fetching 100 rows with each 
 * fetch will usually give you sufficient improvements in performance over 
 * row-by-row fetching.
 * 
 * 3) Only cursor FOR loops are optimized this way, so if you have a simple or
 * WHILE loop that fetches individual rows, you should convert to 
 * BULK COLLECT - with LIMIT!

 * 4) If you are fetching a very large number of rows, such as might happen with 
 * data warehouse processing or a nightly batch process, then you should 
 * experiment with larger LIMIT values to see what kind of "bang for the buck" 
 * you will get.
 * 
 * 5) If your cursor FOR loop (or any other kind of loop for that matter) 
 * contains one or more non-query DML statements (insert, update, delete, 
 * merge), you should convert to BULK COLLECT and FORALL.
 * 
 * Run the following code to see how optimization affects cursor FOR loop 
 * performance.
 */


/* Try different approaches with optimization disabled. */

ALTER PROCEDURE test_ex_cr_impl_cr_for_cr_prf2
COMPILE plsql_optimize_level=0
/

BEGIN
   dbms_output.put_line('----------------------------------------------------');
   dbms_output.put_line('----------------------------------------------------');
   dbms_output.put_line ('No optimization...');
   dbms_output.put_line('----------------------------------------------------');
   dbms_output.put_line('----------------------------------------------------');
   test_ex_cr_impl_cr_for_cr_prf2 ('implicit cursor for loop', 10000, NULL);
   dbms_output.put_line('----------------------------------------------------');
   test_ex_cr_impl_cr_for_cr_prf2 ('explicit open, fetch, close', 10000, NULL);
   dbms_output.put_line('----------------------------------------------------');
   test_ex_cr_impl_cr_for_cr_prf2 ('bulk fetch', 10000, NULL);
   dbms_output.put_line('----------------------------------------------------');
END;
/

/* Try different approaches with default optimization. */

ALTER PROCEDURE test_cursor_performance2
COMPILE plsql_optimize_level=2
/

BEGIN
   dbms_output.put_line('----------------------------------------------------');
   dbms_output.put_line('----------------------------------------------------');
   DBMS_OUTPUT.put_line ('Default optimization...');
   dbms_output.put_line('----------------------------------------------------');
   dbms_output.put_line('----------------------------------------------------');
   test_ex_cr_impl_cr_for_cr_prf2 ('implicit cursor for loop',10000, NULL);
   dbms_output.put_line('----------------------------------------------------');
   test_ex_cr_impl_cr_for_cr_prf2 ('explicit open, fetch, close',10000, NULL);
   dbms_output.put_line('----------------------------------------------------');
   test_ex_cr_impl_cr_for_cr_prf2 ('bulk fetch',10000, NULL);
   dbms_output.put_line('----------------------------------------------------');   
END;
/
