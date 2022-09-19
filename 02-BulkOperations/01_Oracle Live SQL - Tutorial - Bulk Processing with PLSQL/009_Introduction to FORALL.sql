/* 
 * Resource: 
 * ---------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 9. Introduction to FORALL
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
 * We will start with a very simple example, showing the basic conversion from a 
 * loop to FORALL. Then we will explore the many nuances of working with this 
 * powerful feature.
 *
 * In the block below, we have a classic example of the row-by-row 
 * "anti-pattern:" delete each employee in department 50 and 100.

        BEGIN
           FOR emp_rec IN (SELECT t.employee_id
                             FROM saimk.employees t
                            WHERE t.department_id IN (50, 100))
           LOOP
              DELETE 
              FROM saimk.employees t
              WHERE t.employee_id = emp_rec.employee_id
              ;
           END LOOP;
           --
           ROLLBACK;
        END;
 *
 * Now, first of all you might have noticed that this entire loop could be 
 * replaced by a single UPDATE statement, as in:

        DELETE 
        FROM saimk.employees t
        WHERE t.department_id IN (50, 100)
        ;
 *       
 * -----------------------------------------------------------------------------
 * EXAMPLE 1:
 * -----------------------------------------------------------------------------
 * For the purposes of demonstration (and for the remainder of this tutorial), 
 * please assume that there is more going on that justifies the use of FORALL.
 * In which case, here is the rewrite of the original block:
 */
DECLARE
   TYPE ids_t IS TABLE OF saimk.employees.department_id%TYPE;
   l_ids ids_t := ids_t (50, 100);
BEGIN
   FORALL l_index IN 1 .. l_ids.COUNT
      DELETE 
      FROM saimk.employees t
      WHERE t.department_id = l_ids (l_index)
      ;
   --
   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   --
   ROLLBACK;
END
;
/*
 * Here's what we modified to convert to bulk processing:
 *
 * 1) Declare a nested table type of department IDs, and declare a variable based 
 * on that type. Initialize the nested table with two departments.
 * 
 * 2) Replace the FOR loop with a FORALL header. In this simplest of all cases, 
 * it looks just like a numeric FOR loop header, iterating from 1 to the number 
 * of elements in the nested table. Note the implicitly declared l_index 
 * iterator.
 * 
 * 3) Place the DELETE statement "under" the FORALL; replace the IN clause with an 
 * equality check and reference an element in the l_ids bind array using the 
 * l_index iterator; and terminate the whole statement with a semi-colon.
 * 
 * 4) Display the number of rows modified by the entire FORALL statement, and 
 * then rollback changes so that the table is left intact for the next example.
 *
 * That's about as simple an example of FORALL as one could imagine. The real 
 * world is usually a little bit more interesting. For example, you will often 
 * have an array of values that you bind into the WHERE clause and also one or
 * more arrays of values that you use in the SET clause of an update statement 
 * (or to provide values for columns of an INSERT statement in the VALUES 
 * clause).
 *
 * FORALL takes care of all that exactly as you'd expect - but it is up to you 
 * to make sure that the data is in synch across all your collections. 
 * -----------------------------------------------------------------------------
 * EXAMPLE 2:
 * -----------------------------------------------------------------------------
 * In the block below, we update rows by employee ID with a new salary and first 
 * name specific to each ID.
 */
DECLARE
   /* We use pre-defined collection types to reduce code volume. */
   l_ids        DBMS_SQL.number_table;
   l_names      DBMS_SQL.varchar2a;
   l_salaries   DBMS_SQL.number_table;
BEGIN
   l_ids (1) := 101;
   l_ids (2) := 112;
   l_ids (3) := 120;
   --
   l_names (1) := 'Sneezy';
   l_names (2) := 'Bashful';
   l_names (3) := 'Happy';
   --
   l_salaries (1) := 1000;
   l_salaries (2) := 1500;
   l_salaries (3) := 2000;
   --
   FORALL indx IN 1 .. l_ids.COUNT
      UPDATE saimk.employees t
      SET t.first_name = l_names (indx), t.salary = l_salaries (indx)
      WHERE t.employee_id = l_ids (indx)
      ;
   --
   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   --
   FOR emp_rec IN (  SELECT first_name, salary
                     FROM saimk.employees t
                     WHERE t.employee_id IN (101, 112, 120)
                     ORDER BY t.employee_id)
   LOOP
      DBMS_OUTPUT.put_line (emp_rec.first_name || ' - ' || emp_rec.salary);
   END LOOP;
   --
   ROLLBACK;
END
;
/*
 * -----------------------------------------------------------------------------
 * EXAMPLE 3:
 * -----------------------------------------------------------------------------
 * If you do not keep the indexes in synch across all columns, you will get
 * errors, as you will see when you run this block:
 */
DECLARE
   l_ids        DBMS_SQL.number_table;
   l_names      DBMS_SQL.varchar2a;
   l_salaries   DBMS_SQL.number_table;
BEGIN
   l_ids (1) := 101;
   l_ids (2) := 112;
   l_ids (3) := 120;
   --
   l_names (1) := 'Sneezy';
   l_names (100) := 'Happy';
   --
   l_salaries (-1) := 1000;
   l_salaries (200) := 1500;
   l_salaries (3) := 2000;
   --
   FORALL indx IN 1 .. l_ids.COUNT
      UPDATE saimk.employees t
      SET t.first_name = l_names (indx), t.salary = l_salaries (indx)
      WHERE t.employee_id = l_ids (indx)
      ;
   --
   ROLLBACK;
END
;
/*
 * ORA-22160: element at index [N] does not exist
 * So: by all means, you can reference multiple bind arrays, but make sure they 
 * are consistent across index values (often this is not an issue, as the 
 * collections are loaded from the same BULK COLLECT query).
 */

/*
 * Here are some important things to remember about FORALL:
 *
 * 1) Each FORALL statement may contain just a single DML statement. If your 
 * loop contains two updates and a delete, then you will need to write three 
 * FORALL statements.
 *
 * 2) PL/SQL declares the FORALL iterator as an integer, just as it does with a 
 * FOR loop. You do not need to (and should not) declare a variable with this 
 * same name.
 *
 * 3) In at least one place in the DML statement, you need to reference a 
 * collection and use the FORALL iterator as the index value in that collection.
 *
 * 4) When using the IN low_value . . . high_value syntax in the FORALL header, 
 * the collections referenced inside the FORALL statement must be densely 
 * filled. That is, every index value between the low_value and high_value must 
 * be defined.
 *
 * 5) If your collection is not densely filled, you should use the INDICES OF or 
 * VALUES OF syntax in your FORALL header.
 */

/*
 * -----------------------------------------------------------------------------
 * Exercise 6
 * -----------------------------------------------------------------------------
 * Write an anonymous block that uses BULK COLLECT to populate two collections, 
 * one with the employee Id and the other with the employee's last name. Use 
 * those collections in a FORALL statement to update the employee's last name to 
 * the UPPER of the name in the name collection, for each employee ID. 
 * Note: clearly, you do not need BULK COLLECT and FORALL to do this. 
 * Please pretend. :-)
 * ----------------------------------------------------------------------------- 
 * Solution For Exercise 6
 * ----------------------------------------------------------------------------- 
 */
DECLARE
   TYPE ids_t IS TABLE OF saimk.employees.employee_id%TYPE;
   --
   l_ids     ids_t;
   --
   TYPE names_t IS TABLE OF saimk.employees.last_name%TYPE;
   --
   l_names   names_t;
BEGIN
   SELECT t.employee_id, t.last_name
   BULK COLLECT 
   INTO l_ids, l_names
   FROM saimk.employees t
   ORDER BY t.employee_id
   ;
   --
   FORALL indx IN 1 .. l_ids.COUNT
      UPDATE saimk.employees t
      SET t.last_name = UPPER (l_names (indx))
      WHERE t.employee_id = l_ids (indx)
      ;
   --
   FOR indx IN 1..l_names.COUNT LOOP
     dbms_output.put_line(l_ids(indx)||') '||l_names(indx));
   END LOOP;
   --
   ROLLBACK;
END
;