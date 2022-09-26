/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 7. RETURNING and BULK COLLECT
 * ----------------------------------------------------------------------------- 
 * The RETURNING clause is a wonderful thing. If you are inserting, updating or 
 * deleting data, and you need to get some information back after the statement 
 * completes (such as the primary key of the newly-inserted row), RETURNING is 
 * the thing for you! 
 *
 * Here's an example:
 */
/* 
 * ----------------------------------------------------------------------------
 * EXAMPLE 1:
 * ----------------------------------------------------------------------------
 * We create a table named t for this example. After the example we drop this
 * table.
 * ---------------------------------------------------------------------------- 
 */
CREATE TABLE saimk.t (
   id NUMBER GENERATED ALWAYS AS IDENTITY,
   n NUMBER
)
;
--
DECLARE
   l_id t.id%TYPE;
   l_n t.n%TYPE;
BEGIN
   INSERT 
   INTO saimk.t(n) 
   VALUES(100)
   RETURNING t.id, t.n
   INTO l_id, l_n
   ;
   --
   dbms_output.put_line ('l_id-->'||l_id);
   dbms_output.put_line ('l_n-->'||l_n);
   --
END
;
--
DROP TABLE saimk.t;
/*----------------------------------------------------------------------------*/
/*
 * Suppose, however, that we are changing more than one row. Can we use 
 * RETURNING then? 
 *
 * Let's see....
 * 
        DECLARE
           l_id saimk.employees.employee_id%TYPE;
        BEGIN
           UPDATE saimk.employees t
           SET t.last_name = UPPER (t.last_name)
           RETURNING t.employee_id 
           INTO l_id
           ;
           ROLLBACK;
        END;
 *
 * Oh no!
 *
 * ORA-01422: exact fetch returns more than requested number of rows
 * But wait, that's the sort of error you can get with a SELECT-INTO that 
 * returns more than one row. Why is it showing up here?
 * 
 * Because the RETURNING clause is essentially translated into a 
 * SELECT-INTO: get one value and stuff it into l_id. But in this case, the 
 * UPDATE statement is returning many IDs. How do we get this work?
 *
 * BULK COLLECT to the rescue! We need to take multiple values and put them into 
 * something. What could that be? How about a collection? So, yes, if you are 
 * changing one or more rows, change INTO to BULK COLLECT INTO, and provide a 
 * collection to hold the values:
 */
/* 
 * ----------------------------------------------------------------------------
 * EXAMPLE 2:
 * ----------------------------------------------------------------------------
 * We have to use RETURNING with BULK COLLECT with a DML that affects more than 
 * one row.
 * ---------------------------------------------------------------------------- 
 */ 
DECLARE
   TYPE ids_t IS TABLE OF saimk.employees.employee_id%TYPE;
   --
   l_ids ids_t;
   --
   l_cnt NUMBER := 0;
BEGIN
   UPDATE saimk.employees t
   SET t.last_name = UPPER (t.last_name)
   WHERE t.department_id = 50
   RETURNING t.employee_id 
   BULK COLLECT 
   INTO l_ids
   ;
   --
   FOR indx IN 1 .. l_ids.COUNT 
   LOOP
      l_cnt := l_cnt + 1;
      dbms_output.put_line (l_cnt || ') ' || l_ids(indx));
   END LOOP;
   /* 
    * to leave the table in its original state for next examples 
    */
   ROLLBACK;
END
;
/*----------------------------------------------------------------------------*/
/*
 * -----------------------------------------------------------------------------
 * Exercise 4
 * -----------------------------------------------------------------------------
 * Write an anonymous block that deletes all the rows in the employees table for
 * department 50 and returns all the employee IDs and the last names of deleted 
 * rows. Then display those values using dbms_output.put_line. Finally, you 
 * might want to rollback. That will make it easier to test your code - and 
 * continue on with the tutorial.
 */
/* 
 * ----------------------------------------------------------------------------- 
 * Solution 1 For Exercise 4:
 * ----------------------------------------------------------------------------- 
 * Uses a collection of records.
 * We will also list first_name in addition to the actually wanted fields.
 * ----------------------------------------------------------------------------- 
 */
DECLARE
  TYPE l_emp_rt IS RECORD (employee_id saimk.employees.employee_id%TYPE,
                           first_name saimk.employees.first_name%TYPE,
                           last_name saimk.employees.last_name%TYPE
                          );
  --                        
  TYPE l_emp_t IS TABLE OF l_emp_rt INDEX BY PLS_INTEGER;
  --
  l_emps l_emp_t;
  --
BEGIN  
  DELETE
  FROM saimk.employees t
  WHERE t.department_id = 50
  RETURNING t.employee_id, t.first_name, t.last_name
  BULK COLLECT
  INTO l_emps
  ;
  --
  FOR indx IN 1..l_emps.COUNT LOOP
    dbms_output.put_line(indx || ') ' || l_emps(indx).employee_id || ', ' || l_emps(indx).first_name || ', ' || l_emps(indx).last_name);
  END LOOP;
  /* 
   * to leave the table in its original state for next examples 
   */
  ROLLBACK;
END
;
/*----------------------------------------------------------------------------*/
/*
 * ----------------------------------------------------------------------------- 
 * Solution 2 For Exercise 4:
 * -----------------------------------------------------------------------------  
 * 2 separate collections of scalar values to hold the data coming back from the 
 * RETURNING clause
 * ----------------------------------------------------------------------------- 
 */
DECLARE
   TYPE ids_t IS TABLE OF employees.employee_id%TYPE;
   --
   l_ids     ids_t;
   --
   TYPE names_t IS TABLE OF employees.last_name%TYPE;
   --
   l_names   names_t;
BEGIN
   DELETE 
   FROM saimk.employees t
   WHERE t.department_id = 50
   RETURNING t.employee_id, t.last_name
   BULK COLLECT 
   INTO l_ids, l_names
   ;
   --
   FOR indx IN 1 .. l_ids.COUNT
   LOOP
      dbms_output.put_line (l_ids (indx) || ' - ' || l_names (indx));
   END LOOP;
   /* 
    * to leave the table in its original state for next examples 
    */
   ROLLBACK;
END
;
/*----------------------------------------------------------------------------*/