/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 4. Introduction to BULK COLLECT (Bulk processing for queries)
 * -----------------------------------------------------------------------------
 * To take advantage of bulk processing for queries, you simply put BULK COLLECT 
 * before the INTO keyword of your fetch operation, and then provide one or more 
 * collections after the INTO keyword.
 * ----------------------------------------------------------------------------
 * Here are some things to know about how BULK COLLECT works:
 * ----------------------------------------------------------------------------
 * 1) It can be used with all three types of collections: associative arrays, 
 * nested tables, and VARRAYs.
 * 
 * 2) You can fetch into individual collections (one for each expression in the 
 * SELECT list) or a single collection of records.
 *
 * 3) The collection is always populated densely, starting from index value 1.
 * 
 * 4) If no rows are fetched, then the collection is emptied of all elements.
 * ----------------------------------------------------------------------------
 * You can use BULK COLLECT in all these forms:
 * ----------------------------------------------------------------------------
 *       1) SELECT column(s) BULK COLLECT INTO collection(s) FROM ...
 *       2) FETCH cursor BULK COLLECT INTO collection(s)
 *       3) EXECUTE IMMEDIATE query_string BULK COLLECT INTO collection(s)
 * ----------------------------------------------------------------------------        
 */
/* 
 * ----------------------------------------------------------------------------
 * EXAMPLE 1:
 * ----------------------------------------------------------------------------
 * Here's a block of code that fetches all rows in the employees table with a 
 * single context switch, and loads the data into a collection of records 
 * that are based on the table.
 * ----------------------------------------------------------------------------
 */
DECLARE
  TYPE employee_info_t IS TABLE OF saimk.employees%ROWTYPE INDEX BY PLS_INTEGER;
  --
  l_emps employee_info_t;
BEGIN
   SELECT t.* 
   BULK COLLECT
   INTO l_emps
   FROM saimk.employees t
   ORDER BY t.employee_id
   ;
   --
   dbms_output.put_line('----------------------------------------------------');
   dbms_output.put_line('#Rows Fetched by Bulk Collect In a Single Context Switch: ' || l_emps.COUNT);   
   dbms_output.put_line('----------------------------------------------------');
   dbms_output.put_line('Employees List');
   dbms_output.put_line('----------------------------------------------------');
   --
   FOR indx IN 1..l_emps.COUNT 
   LOOP
      dbms_output.put_line(indx || ')' || l_emps(indx).employee_id || ', ' || l_emps(indx).first_name || ', ' || l_emps(indx).last_name || ', ' || l_emps(indx).salary);
   END LOOP;
   --
END;   
/*----------------------------------------------------------------------------*/
/*
 * If you do not want to retrieve all the columns in a table, create your own 
 * user-defined record type and use that to define your collection. All you have 
 * to do is make sure the list of expressions in the SELECT match the record 
 * type's fields.
 * ----------------------------------------------------------------------------
 * EXAMPLE 2:
 * ----------------------------------------------------------------------------
 */
DECLARE
   TYPE two_cols_rt IS RECORD (
      employee_id saimk.employees.employee_id%TYPE,
      salary saimk.employees.salary%TYPE
   );
   --
   TYPE employee_info_t IS TABLE OF two_cols_rt;
   --
   l_employees employee_info_t;
BEGIN
   SELECT t.employee_id, t.salary
   BULK COLLECT
   INTO l_employees
   FROM saimk.employees t
   WHERE t.department_id = 50
   ;
   --
   dbms_output.put_line (l_employees.COUNT);
END;
/*----------------------------------------------------------------------------*/
/* ----------
 * Quick Tip:
 * ----------
 * You can avoid the nuisance of declaring a record type to serve as the type 
 * for the collection through the use of a "template cursor." This cursor should 
 * have the same select list as the BULK COLLECT query. You can, however, leave 
 * off the WHERE clause and anything else after the FROM clause, because it will 
 * never be used for anything but a %ROWTYPE declaration. 
 *
 * Here's an example:
 * ----------------------------------------------------------------------------
 * EXAMPLE 3:
 * ----------------------------------------------------------------------------
 */
DECLARE
   CURSOR employee_info_c IS
   SELECT t.employee_id, t.salary 
   FROM saimk.employees t
   ;
   --
   TYPE employee_info_t IS TABLE OF employee_info_c%ROWTYPE;
   --
   l_employees employee_info_t;
BEGIN
   SELECT t.employee_id, t.salary
   BULK COLLECT
   INTO l_employees
   FROM saimk.employees t
   WHERE t.department_id = 10
   ;
   --
   dbms_output.put_line (l_employees.COUNT);
END;
/*----------------------------------------------------------------------------*/
/*
 * -----------------------------------------------------------------------------
 * Exercise 1
 * -----------------------------------------------------------------------------
 * Write a stored procedure that accepts a department ID, uses BULK COLLECT to
 * retrieve all employees in that department, and displays their first name and
 * salary. Then write an anonymous block to run that procedure for department 
 * 100.
 * ----------------------------------------------------------------------------- 
 */
/* 
 * ----------------------------------------------------------------------------- 
 * Solution For Exercise 1:
 * -----------------------------------------------------------------------------
 * We will also list last_name in addition to the actually wanted fields.
 * ----------------------------------------------------------------------------- 
 */
CREATE OR REPLACE PROCEDURE saimk.p_list_employee_name_and_salary_by_department_id(p_dept_id NUMBER)
IS
  /*
   * @author	Saim Kuru
   * @version 1.0
   * Created for Bulk Processing with PL/SQL Tutorial on 
   * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
   */
    TYPE l_emp_rt IS RECORD(fn saimk.employees.first_name%TYPE, 
                            ln saimk.employees.last_name%TYPE, 
                            sl saimk.employees.salary%TYPE
                            );
    --                   
    TYPE l_emp_t IS TABLE OF l_emp_rt;
    --
    l_emps l_emp_t;
BEGIN
    SELECT t.first_name, t.last_name, t.salary
    BULK COLLECT
    INTO l_emps
    FROM saimk.employees t
    WHERE t.department_id = p_dept_id
    ORDER BY t.first_name, t.last_name
    ;
    --
    FOR indx IN 1..l_emps.COUNT LOOP
        dbms_output.put_line(indx || ') ' || l_emps(indx).fn || ', ' || l_emps(indx).ln || ', ' || l_emps(indx).sl);
    END LOOP;
END p_list_employee_name_and_salary_by_department_id;
--
BEGIN
   saimk.p_list_employee_name_and_salary_by_department_id(100);
END;
/*----------------------------------------------------------------------------*/