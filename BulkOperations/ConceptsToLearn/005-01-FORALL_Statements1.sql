/*
 * Source: https://livesql.oracle.com/apex/f?p=590:1:4704207031745:CLEAR::1:TUTORIAL_ID,P1_SHOW_LEARN_SIDEBAR:182241645422959190146194127811898911783,Y
 * -----------------------------------------------------------------------------
 * Introduction to FORALL
 * -----------------------------------------------------------------------------
 * Whenever you execute a non-query DML statement inside of a loop, you should 
 * convert that code to use FORALL - and that's if you cannot get rid of the 
 * loop entirely and handle the requirement with "pure SQL."
 *
 * The FORALL statement is not a loop; it is a declarative statement to the 
 * PL/SQL engine: “Generate all the DML statements that would have been executed
 * one row at a time, and send them all across to the SQL engine with one 
 * context switch.”
 *
 * We will start with a very simple example, showing the basic conversion from 
 * a loop to FORALL.
 *
 * In the block below, we have a classic example of the row-by-row 
 * "anti-pattern:" delete each employee in department 20 and 40.
 * -----------------------------------------------------------------------------
 */

DECLARE
    l_row_cnt NUMBER := 0;
BEGIN
   FOR emp_rec IN (SELECT empno
                     FROM SAIMK.emp
                    WHERE deptno IN (20, 40))
   LOOP
      --
      DELETE FROM SAIMK.emp
            WHERE empno = emp_rec.empno;
      --      
      l_row_cnt := l_row_cnt + SQL%ROWCOUNT; 
      --
   END LOOP;
   --
   DBMS_OUTPUT.PUT_LINE('Info-->'||l_row_cnt||' rows deleted row-by-row, and is being ROLLBACKed.');
   --
   ROLLBACK;
END;

/*
 * For the purposes of demonstration , please assume that there is more going 
 * on that justifies the use of FORALL. In which case, here is the rewrite 
 * of the original block:
 */
DECLARE
   TYPE ids_t IS TABLE OF SAIMK.emp.deptno%TYPE;
   l_ids ids_t := ids_t (20, 40);
   --
BEGIN
   --
   FORALL l_index IN 1 .. l_ids.COUNT
   DELETE FROM SAIMK.emp
   WHERE deptno = l_ids (l_index)
   ;
   --
   DBMS_OUTPUT.PUT_LINE('Info-->'||SQL%ROWCOUNT||' rows deleted by "FORALL", and is being ROLLBACKed.');
   --
   ROLLBACK;
   --
END;

/*
 * Here's what we modified to convert to bulk FORALL processing:
 * 
 * 1) Declare a nested table type of department NOs, and declare a variable 
 * based on that type. Initialize the nested table with two departments.
 * 2) Replace the FOR loop with a FORALL header. In this simplest of all cases, 
 * it looks just like a numeric FOR loop header, iterating from 1 to the number 
 * of elements in the nested table. Note the implicitly declared l_index 
 * iterator.
 * 3) Place the DELETE statement "under" the FORALL; 
 * replace the IN clause with an equality check and reference an element in the 
 * l_ids bind array using the l_index iterator; and terminate the whole 
 * statement with a semi-colon.
 * Display the number of rows modified by the entire FORALL statement, and then 
 * rollback changes so that the table is left intact for the next study.
 */
