/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 5. Managing PGA Memory with the LIMIT Clause
 * ----------------------------------------------------------------------------- 
 * As with almost all other types of variables and constants you use in your 
 * code, collections consume PGA (process global area) memory. If your 
 * collection gets too large, your users might encounter an error.
 *
 * To see this happen, run the code below in EXAMPLE 1.
 *
 * -----
 * Note:
 * -----
 * varchar2a is a collection type of strings defined in the DBMS_SQL package.
 */
 /* 
 * ----------------------------------------------------------------------------
 * EXAMPLE 1:
 * ----------------------------------------------------------------------------
 * Here is a block of code in which our collection gets too large resulting in
 * an error. Error report for this error is such:
 *
 * Error report -
 * ORA-04036: PGA memory used by the instance exceeds PGA_AGGREGATE_LIMIT
   04036. 00000 -  "PGA memory used by the instance exceeds PGA_AGGREGATE_LIMIT"
 * *Cause:    Private memory across the instance exceeded the limit specified
              in the PGA_AGGREGATE_LIMIT initialization parameter.  The largest
              sessions using Program Global Area (PGA) memory were interrupted
              to get under the limit.
 * *Action:   Increase the PGA_AGGREGATE_LIMIT initialization parameter or 
 *            reduce memory usage. 
 * -----------------------------------------------------------------------------
 * Notes:
 * -----------------------------------------------------------------------------
 * PGA_AGGREGATE_LIMIT: specifies a limit on the aggregate PGA memory consumed 
 * by the instance. The value can be listed such:
 * 
       SELECT * FROM V$PARAMETER t WHERE UPPER(t.NAME) = 'PGA_AGGREGATE_LIMIT';
 * -----------------------------------------------------------------------------       
 */ 
DECLARE
   l_strings   dbms_sql.varchar2a;
BEGIN
   FOR indx IN 1 .. 2 ** 31 - 1
   LOOP
      l_strings (indx) := RPAD ('abc', 32767, 'def');
   END LOOP;
END;
/*----------------------------------------------------------------------------*/
/* 
 * When using BULK COLLECT, you could attempt to retrieve too many rows in one 
 * context switch and run out of PGA memory. To help you avoid such errors, 
 * Oracle Database offers a LIMIT clause for BULK COLLECT. 
 * 
 * Indeed, when using BULK COLLECT we recommend that you never or at least 
 * rarely use an "unlimited" BULK COLLECT which is what you get with a 
 * SELECT BULK COLLECT INTO (an implicit query) - and you saw in the previous 
 * module.
 *
 * Instead, declare a cursor (or a cursor variable), open that cursor, and then 
 * in a loop, retrieve N number of rows with each fetch.
 */
/* ----------------------------------------------------------------------------
 * EXAMPLE 2: USING BULK COLLECT with LIMIIT
 * ----------------------------------------------------------------------------
 * In the block below, we set our fetch limit to just 10 rows to demonstrate how 
 * this feature works. You will likely never want to set the limit to less than 
 * 100 - this topic is explored further below.
 * ---------------------------------------------------------------------------- 
 */
DECLARE
   C_LIMIT CONSTANT PLS_INTEGER := 10;
   --
   CURSOR employees_cur
   IS
   SELECT t.employee_id
   FROM saimk.employees t
   WHERE t.department_id = 50
   ;
   --
   TYPE employee_ids_t IS TABLE OF saimk.employees.employee_id%TYPE;
   --
   l_employee_ids employee_ids_t;
BEGIN
   OPEN employees_cur;
   --
   LOOP
      FETCH employees_cur
      BULK COLLECT 
      INTO l_employee_ids
      LIMIT C_LIMIT
      ;
      --
      dbms_output.put_line ('#Rows fetched: ' || l_employee_ids.COUNT);
      --
      EXIT WHEN l_employee_ids.COUNT = 0;
   END LOOP;
   --
   CLOSE employees_cur;
END;
/*----------------------------------------------------------------------------*/
/* 
 * One thing to watch out for when switching to LIMIT with BULK COLLECT 
 * (in a loop) is following the same pattern for single-row fetching in a loop.
 * 
 * We demonstrate this issue below, but first, a reminder: there are 107 rows in 
 * the employees table.
 *
 * SELECT COUNT(1) FROM saimk.employees t;
 *
 * Here is the common way to terminate a loop in which you fetch row-by-row from 
 * an explicit cursor:
 *
        DECLARE
           CURSOR emps_c 
           IS 
           SELECT t.* 
           FROM saimk.employees t
           ;
           --
           l_emp   emps_c%ROWTYPE;
           l_count INTEGER := 0;
        BEGIN
           OPEN emps_c;
           --
           LOOP
              FETCH emps_c 
              INTO l_emp
              ;
              --
              EXIT WHEN emps_c%NOTFOUND;
              --
              dbms_output.put_line (l_emp.employee_id);
              --
              l_count := l_count + 1;
           END LOOP;
           --
           dbms_output.put_line ('#Total rows fetched: ' || l_count);
        END;
 *
 * In other words: fetch a row, stop if the cursor has retrieved all rows. 
 * Now let us switch to using BULK COLLECT and LIMIT, fetching 10 rows at a time, 
 * using the same approach to exiting the loop.
 *
        DECLARE
           CURSOR emps_c 
           IS 
           SELECT t.* 
           FROM saimk.employees t
           ;
           --
           TYPE emps_t IS TABLE OF emps_c%ROwTYPE;
           --
           l_emps emps_t;
           l_count INTEGER := 0;
        BEGIN
           OPEN emps_c;
           --
           LOOP
              FETCH emps_c 
              BULK COLLECT 
              INTO l_emps 
              LIMIT 10
              ;
              --
              EXIT WHEN emps_c%NOTFOUND;
              --
              dbms_output.put_line (l_emps.COUNT);
              --
              l_count := l_count + l_emps.COUNT;
           END LOOP;
           --
           dbms_output.put_line ('#Total rows fetched: ' || l_count);
        END;
 *
 * Wait, what? Is that right? Do we see "Total rows fetched: 100"? Yes, we do. 
 * And therein lies the trap. You cannot continue to use the same EXIT WHEN 
 * statement in the same place in your loop when you switch to BULK COLLECT with 
 * LIMIT.
 *
 * The very last fetch performed retrieved the last 7 rows, but also exhausted 
 * the cursor. So the %NOTFOUND returns TRUE, while the collection has those 
 * 7 elements in it.
 *
 * To terminate a loop using BULK COLLECT with LIMIT, you should either:
 *
 * -> Move the EXIT WHEN to the bottom of the loop body, or
 * -> Ignore the cursor and check the collection. When empty, terminate.
 * 
 * These two approaches are shown below.
 *
        DECLARE
           CURSOR emps_c 
           IS 
           SELECT t.* 
           FROM saimk.employees t
           ;
           --
           TYPE emps_t IS TABLE OF emps_c%ROwTYPE;
           --
           l_emps emps_t;
           l_count INTEGER := 0;
        BEGIN
           OPEN emps_c;
           --
           LOOP
              FETCH emps_c 
              BULK COLLECT 
              INTO l_emps 
              LIMIT 10
              ;
              --
              l_count := l_count + l_emps.COUNT;
              --
              EXIT WHEN emps_c%NOTFOUND;
           END LOOP;
           --
           dbms_output.put_line ('#Total rows fetched: ' || l_count);
           --
           CLOSE emps_c;
        END;
 *
        DECLARE
           CURSOR emps_c IS 
           SELECT t.* 
           FROM saimk.employees t
           ;
           --
           TYPE emps_t IS TABLE OF emps_c%ROwTYPE;
           --
           l_emps emps_t;
           l_count INTEGER := 0;
        BEGIN
           OPEN emps_c;
           --
           LOOP
              FETCH emps_c 
              BULK COLLECT 
              INTO l_emps 
              LIMIT 10
              ;
              --
              EXIT WHEN l_emps.COUNT = 0;
              --
              l_count := l_count + l_emps.COUNT;
           END LOOP;
           --
           dbms_output.put_line ('#Total rows fetched: ' || l_count);
           --
           CLOSE emps_c;
        END;
 *
 */
/* 
 * -----------------------------------------------------------------------------
 * Exercise 2
 * -----------------------------------------------------------------------------
 * Write an anonymous block that fetches (using BULK COLLECT) only the last name 
 * and salary from the employees table 5 rows at a time, and then displays that 
 * information. Make sure 107 names and salaries are shown!
 * ----------------------------------------------------------------------------- 
 */
/*
 * ----------------------------------------------------------------------------- 
 * Solution For Exercise 2
 * -----------------------------------------------------------------------------  
 * We will also list first_name in addition to the actually wanted fields.
 * ----------------------------------------------------------------------------- 
 */
DECLARE
  C_LIMIT CONSTANT PLS_INTEGER := 5;
  l_cnt NUMBER := 0;
  --
  TYPE l_emp_rt IS RECORD(first_name saimk.employees.first_name%TYPE,
                          last_name saimk.employees.last_name%TYPE,
                          salary saimk.employees.salary%TYPE
                         ); 
  --
  TYPE l_emp_t IS TABLE OF l_emp_rt INDEX BY PLS_INTEGER;
  --
  l_emps l_emp_t;
  --
  CURSOR c_emps 
  IS
  SELECT t.first_name, t.last_name, t.salary
  FROM saimk.employees t
  ORDER BY t.first_name, t.last_name
  ;
BEGIN
  OPEN c_emps;
  --
  LOOP
    FETCH c_emps
    BULK COLLECT
    INTO l_emps
    LIMIT C_LIMIT
    ;
    --
    EXIT WHEN l_emps.COUNT = 0;
    --
    FOR indx IN 1..l_emps.COUNT LOOP
      l_cnt := l_cnt + 1;
      dbms_output.put_line(l_cnt || ') ' || l_emps(indx).first_name || ', ' ||l_emps(indx).last_name|| ', ' ||l_emps(indx).salary);
    END LOOP;     
  END LOOP;
  --
  CLOSE c_emps; 
END;
/*----------------------------------------------------------------------------*/