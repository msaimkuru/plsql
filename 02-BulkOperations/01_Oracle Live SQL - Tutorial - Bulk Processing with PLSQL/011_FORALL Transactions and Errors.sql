/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 11. FORALL, Transactions, and Errors
 * ----------------------------------------------------------------------------- 
 * So many errors can occur when you are trying to change rows in a table. 
 * Constraint violations, values too large for columns....now add to that the 
 * fact that with FORALL you are executing that DML statement many times over. 
 * Managing errors with FORALL is a tricky and important thing to do!
 *
 * Before diving into the error-related features of FORALL, let's review some 
 * important points about transactions, errors and exceptions in the world of 
 * PL/SQL.
 *
 * 1) If the SQL engine raises an error back to the PL/SQL engine, that does not 
 * cause an automatic rollback of previously successful DML statements. They are 
 * still waiting to be committed or rolled back.
 *
 * 2) If an exception goes unhandled out of PL/SQL (back to, say, SQL*Plus or 
 * SQL Developer or your APEX app), then a rollback will always be performed.
 * 
 * 3) Each SQL statement is atomic ("all or nothing"), unless you use the 
 * LOG ERRORS feature. In other words, if your update statement finds 100 rows 
 * to change, and as it is changing the 100th of them, it hits an error, the 
 * changes to all 100 rows are reversed.
 *
 * 4) LOG ERRORS is a SQL feature that allows you to suppress errors at the row 
 * level, avoiding the "all or nothing" scenario. We are not exploring 
 * LOG ERRORS in this tutorial. We just wanted to make sure you are aware. :-) 
 * Oh and search LiveSQL for "log errors" to see a script or two on that
 * feature.
 * 
 * What does this for FORALL? That, by default, the first time the SQL engine 
 * encounters an error processing the DML statement passed to it from FORALL, 
 * it stops and passes the error back to the PL/SQL engine. No further 
 * processing is done, but also any statements completed successfully by the 
 * FORALL are still waiting to be committed or rolled back.
 * 
 * You can see this behavior in the example code below 
 */
/*
 * -----------------------------------------------------------------------------
 * EXAMPLE 1: Error occuring during the last SQL stataement of a FORALL process
 * ----------------------------------------------------------------------------- 
 * (note the constraint on the size of numbers in the n column: 1 and 10 are OK, 
 * 100 is too large).
 * ----------------------------------------------------------------------------- 
 */ 
CREATE TABLE saimk.mynums(n NUMBER (2))
;
--
DECLARE
   TYPE numbers_t IS TABLE OF NUMBER;
   --
   l_numbers numbers_t := numbers_t(1, 10, 100);
BEGIN
   FORALL indx IN 1 .. l_numbers.COUNT
      INSERT INTO mynums (n)
      VALUES (l_numbers (indx))
      ;
   /* 
    * to leave the table in its original state for next examples 
    */
   ROLLBACK;       
   --  
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line ('#With FORALL Updated Totally ' || SQL%ROWCOUNT || ' rows.');
         --
         FOR l_index IN 1..l_numbers.COUNT LOOP
            dbms_output.put_line ('At FORALL step ' || l_index || ' Updated ' || SQL%BULK_ROWCOUNT(l_index) || ' rows.');
         END LOOP;
         --
         dbms_output.put_line('SQLERRM: ' || SQLERRM);
         /* 
          * to leave the table in its original state for next examples 
          */
         ROLLBACK;
END
;
/*
 * -----------------------------------------------------------------------------
 * EXAMPLE 2: Error occuring during the first SQL stataement of a FORALL process
 * ----------------------------------------------------------------------------- 
 * (note the constraint on the size of numbers in the n column: 1 and 10 are OK, 
 * 100 is too large).
 * ----------------------------------------------------------------------------- 
 */ 
DECLARE
   TYPE numbers_t IS TABLE OF NUMBER;
   --
   l_numbers   numbers_t := numbers_t (100, 10, 1);
BEGIN
   FORALL indx IN 1 .. l_numbers.COUNT
      INSERT INTO mynums (n)
      VALUES (l_numbers (indx))
      ;
   /* 
    * to leave the table in its original state for next examples 
    */
   ROLLBACK; 
   --
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line('#With FORALL Updated Totally ' || SQL%ROWCOUNT || ' rows.');
         --
         FOR l_index IN 1..l_numbers.COUNT LOOP
            dbms_output.put_line('At FORALL step ' || l_index || ' Updated ' || SQL%BULK_ROWCOUNT(l_index) || ' rows.');
         END LOOP;
         --
         dbms_output.put_line('SQLERRM:' || SQLERRM);
         /* 
          * to leave the table in its original state for next examples 
          */
         ROLLBACK; 
END
;
--
DROP TABLE saimk.mynums;
--
/*----------------------------------------------------------------------------*/
/*
 * The first block updated 2 rows, the second block updated 0 rows. You see here 
 * the "shortcutting" that the SQL engine does with your FORALL DML statement 
 * and the array of bind variables.
 *
 * This is entirely consistent with non-bulk behavior. By which I mean: if you 
 * have a block that executes an insert, then another insert, then a delete and 
 * finally an update, the PL/SQL and SQL engines will keep on going just as long 
 * as they can, stop when there is an error, and leave it to you, the developer, 
 * to decide what to do about it.
 *
 * But there is a difference between a non-bulk multi-DML set of statements and 
 * FORALL: with the non-bulk approach, you can tell the PL/SQL engine to 
 * continue past a failed SQL statement by putting it inside a nested block, 
 * as in:
 *
        BEGIN
           BEGIN
              INSERT INTO ...
           EXCEPTION 
              WHEN OTHERS 
              THEN
                  log_error ...
           END;
        
           BEGIN
              UPDATE ...
           EXCEPTION 
              WHEN OTHERS 
              THEN
                  log_error ...
           END;
        END;
 *
 * Note: We are not recommending that you do surround each non-query DML 
 * statement in a nested table, trapping any exception, and then continuing. Not 
 * at all. We are saying: it is possible, and you can choose to do this if you'd 
 * like. 
 * 
 * What about with FORALL?
 *
 * With FORALL, you are choosing to execute the same statement, many times over. 
 * 
 * It could be that you do want to stop your FORALL as soon as any statement 
 * fails. In which case, you are done. If, however, you want to keep on going, 
 * even if there is a SQL error for a particular set of bind variable values, 
 * you need to take advantage of the SAVE EXCEPTIONS clause.
 */
/*----------------------------------------------------------------------------*/ 
/*
 * -----------------------------------------------------------------------------
 * Exercise 9
 * -----------------------------------------------------------------------------
 * Complete the block below as follows: 
 *
 * - Use FORALL to update the salaries of 
 * employees whose IDs are in l_ids with the corresponding salary in l_salaries. 
 * 
 * - Display the total number of employees modified. 
 *
 * - First, use values for salaries that will allow all statements to complete 
 * successfully (salary is defined as NUMBER (8,2). Then change the salary 
 * values to explore the different ways that FORALL deals with errors.
 *
        DECLARE
           TYPE numbers_nt IS TABLE OF NUMBER;
           --
           l_ids numbers_nt := numbers_nt (101, 111, 131);
           l_salaries numbers_nt := numbers_nt (#FINISH#);
        BEGIN
           #FINISH#
        END;
 *
 */
/* 
 * ----------------------------------------------------------------------------- 
 * Solution For Exercise 9
 * ----------------------------------------------------------------------------- 
 */
DECLARE
   /* Solution 9.1: All valid, 3 rows should be updated. */
   TYPE numbers_nt IS TABLE OF NUMBER;
   --
   l_ids        numbers_nt := numbers_nt (101, 111, 131);
   l_salaries   numbers_nt := numbers_nt (10000, 11000, 12000);
BEGIN
   FORALL indx IN 1 .. l_ids.COUNT
      UPDATE saimk.employees t
      SET t.salary = l_salaries(indx)
      WHERE t.employee_id = l_ids(indx)
      ;
   --
   dbms_output.put_line ('#Rows Updated: ' || SQL%ROWCOUNT);
   /* 
    * to leave the table in its original state for next examples 
    */
   ROLLBACK;
END
;
--
DECLARE
   /*  Solution 9.2: First one too big so no rows updated. */
   TYPE numbers_nt IS TABLE OF NUMBER;
   --
   l_ids        numbers_nt := numbers_nt (101, 111, 131);
   l_salaries   numbers_nt := numbers_nt (1000000, 11000, 12000);
BEGIN
   FORALL indx IN 1 .. l_ids.COUNT
      UPDATE saimk.employees t
      SET t.salary = l_salaries(indx)
      WHERE t.employee_id = l_ids(indx)
      ;
   --
   dbms_output.put_line ('#Rows Updated: ' || SQL%ROWCOUNT);
   /* 
    * to leave the table in its original state for next examples 
    */
   ROLLBACK;
   --
   EXCEPTION
      WHEN OTHERS THEN
          dbms_output.put_line(SQLERRM);
          dbms_output.put_line ('#Rows Updated: ' || SQL%ROWCOUNT);
          /* 
           * to leave the table in its original state for next examples 
           */      
          ROLLBACK;
END
;
--
DECLARE
   /*  Solution 9.3: Last one too big so 2 rows updated. */
   TYPE numbers_nt IS TABLE OF NUMBER;
   --
   l_ids        numbers_nt := numbers_nt (101, 111, 131);
   l_salaries   numbers_nt := numbers_nt (10000, 11000, 1200000);
BEGIN
   FORALL indx IN 1 .. l_ids.COUNT
      UPDATE saimk.employees t
      SET t.salary = l_salaries (indx)
      WHERE t.employee_id = l_ids (indx)
      ;
   --
   dbms_output.put_line ('#Rows Updated: ' || SQL%ROWCOUNT);
   /* 
    * to leave the table in its original state for next examples 
    */
   ROLLBACK;
   --
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line(SQLERRM);
         dbms_output.put_line('#Rows Updated: ' || SQL%ROWCOUNT);
         /* 
          * to leave the table in its original state for next examples 
          */      
         ROLLBACK;
END
;
/*----------------------------------------------------------------------------*/