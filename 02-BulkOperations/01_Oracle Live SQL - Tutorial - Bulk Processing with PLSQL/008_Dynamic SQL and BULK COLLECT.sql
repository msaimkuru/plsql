/* 
 * Resource: 
 * ---------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 8. Dynamic SQL and BULK COLLECT
 * You can also use BULK COLLECT with native dynamic SQL queries that might 
 * return more than one row. As with SELECT-INTO and FETCH-INTO, just stick that 
 * "BULK COLLECT" before the INTO and provide a collection (or multiple) to hold 
 * the multiple values returned.
 */
/* 
 * ----------------------------------------------------------------------------
 * EXAMPLE 1:
 * ----------------------------------------------------------------------------
 * In this example we use BULK COLLECT with a native dynamic SQL query
 * ----------------------------------------------------------------------------
 */
DECLARE
   TYPE ids_t IS TABLE OF saimk.employees.employee_id%TYPE;

   l_ids   ids_t;
BEGIN
   EXECUTE IMMEDIATE
      'SELECT t.employee_id 
       FROM saimk.employees t
       WHERE t.department_id = :dept_id'
   BULK COLLECT 
   INTO l_ids
   USING 50
   ;
   --
   FOR indx IN 1 .. l_ids.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_ids (indx));
   END LOOP;
END
;
/*
 * ----------------------------------------------------------------------------
 * EXAMPLE 2:
 * ----------------------------------------------------------------------------
 * You can even get "fancy" and use BULK COLLECT in the RETURNING clause of a 
 * dynamic DML statement:
 */
DECLARE
   TYPE ids_t IS TABLE OF saimk.employees.employee_id%TYPE;
   l_ids ids_t;
BEGIN
   EXECUTE IMMEDIATE
      'UPDATE saimk.employees t
       SET t.last_name = UPPER (last_name)
       WHERE t.department_id = 100
       RETURNING t.employee_id 
       INTO :ids'
   RETURNING 
   BULK COLLECT 
   INTO l_ids
   ;
   --
   FOR indx IN 1 .. l_ids.COUNT 
   LOOP
      DBMS_OUTPUT.PUT_LINE (l_ids (indx));
   END LOOP;
   --
   ROLLBACK;
END
;

/*
 * -----------------------------------------------------------------------------
 * Exercise 5
 * -----------------------------------------------------------------------------
 * Write the rest of the procedure whose signature is shown below. 
 * Use BULK COLLECT to fetch all the last names from employees identified by 
 * that WHERE clause and return the collection. Then write an anonymous block to 
 * test your procedure: 
 * pass different WHERE clauses, and display names retrieved.
        PROCEDURE get_names (
            where_in IN VARCHAR2,
            names_out OUT DBMS_SQL.VARCHAR2_TABLE
        ) 
 * ----------------------------------------------------------------------------- 
 * Solution For Exercise 5:
 * ----------------------------------------------------------------------------- 
 * We make the code to list first_name and salary in addition to last_name
 * ----------------------------------------------------------------------------- 
 */
DECLARE
    l_first_names dbms_sql.varchar2_table;
    l_last_names dbms_sql.varchar2_table;
    l_salaries dbms_sql.number_table;
    --
    PROCEDURE p_get_emp_info (
       where_in IN VARCHAR2,
       l_first_names_out OUT dbms_sql.varchar2_table,
       l_last_names_out OUT dbms_sql.varchar2_table,
       l_salaries_out OUT dbms_sql.number_table
    )
    IS 
    BEGIN
      EXECUTE IMMEDIATE 'SELECT t.first_name, t.last_name, t.salary
                         FROM SAIMK.employees t
                         WHERE ' ||
                         where_in
      BULK COLLECT 
      INTO l_first_names_out, l_last_names_out, l_salaries_out
      ; 
    END p_get_emp_info;
BEGIN
  --
  p_get_emp_info('t.department_id = 50 AND UPPER(t.last_name) LIKE ''B%''', l_first_names, l_last_names, l_salaries);
  dbms_output.put_line('----------------------------------------');
  dbms_output.put_line ('For department_id = 50, and last_name starting with b or B'); 
  dbms_output.put_line('----------------------------------------');  
  --
  FOR indx IN 1..l_last_names.COUNT LOOP
    dbms_output.put_line(LPAD(indx, 3, ' ')||')'||l_first_names(indx)||', '||l_last_names(indx)||', '||l_salaries(indx));
  END LOOP;   
  --
  p_get_emp_info ('salary > 15000', l_first_names, l_last_names, l_salaries);
  dbms_output.put_line('----------------------------------------');
  dbms_output.put_line ('For salary > 15000'); 
  dbms_output.put_line('----------------------------------------');
  --
  FOR indx IN 1..l_last_names.COUNT LOOP
    dbms_output.put_line(LPAD(indx, 3, ' ')||')'||l_first_names(indx)||', '||l_last_names(indx)||', '||l_salaries(indx));
  END LOOP;   
END
;