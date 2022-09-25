/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 2. Context Switch and The Row by Row Problem
 * -----------------------------------------------------------------------------
 * Almost every program Oracle Database developers write includes both PL/SQL 
 * and SQL statements. 
 * 
 * PL/SQL statements are run by the PL/SQL statement executor; SQL statements 
 * are run by the SQL statement executor. When the PL/SQL runtime engine 
 * encounters a SQL statement, it stops and passes the SQL statement over to the 
 * SQL engine. The SQL engine executes the SQL statement and returns information 
 * back to the PL/SQL engine. 
 * 
 * This transfer of control is called a context switch, and each one of these 
 * switches incurs overhead that slows down the overall performance of your 
 * programs.
 *
 * Let’s look at a concrete example to explore context switches more thoroughly 
 * and identify the reason that FORALL and BULK COLLECT can have such a dramatic 
 * impact on performance.
 * 
 * Suppose my manager asked me to write a procedure that accepts a department ID 
 * and a salary percentage increase and gives everyone in that department a 
 * raise by the specified percentage. Taking advantage of PL/SQL’s elegant 
 * cursor FOR loop and the ability to call SQL statements natively in PL/SQL, I
 * can implement this requirement easily:
 *
        CREATE OR REPLACE PROCEDURE P_increase_salary(
           p_department_id_in   IN saimk.employees.department_id%TYPE,
           p_increase_pct_in    IN NUMBER)
        IS
        BEGIN
           FOR employee_rec
              IN (SELECT t.employee_id
                    FROM saimk.employees t
                   WHERE t.department_id =
                            p_increase_salary.p_department_id_in
                 )
           LOOP
              UPDATE saimk.employees emp
              SET emp.salary = emp.salary + 
                  emp.salary * p_increase_salary.p_increase_pct_in
              WHERE emp.employee_id = employee_rec.employee_id
              ;
              --
              dbms_output.put_line ('#Updated Rows:' || SQL%ROWCOUNT);
           END LOOP;
        END p_increase_salary;
 * 
 * Suppose there are 10000 employees in department 50. When I execute this 
 * block....
 *
        BEGIN
           p_increase_salary (50, .10);
           ROLLBACK; -- to leave the table in its original state
        END;
 *
 * ....the PL/SQL engine will “switch” over to the SQL engine 10000 times, once 
 * for each row being updated. Tom Kyte of AskTom fame 
 * (https://asktom.oracle.com) refers to row-by-row switching like this as 
 * “slow-by-slow processing,” and it is definitely something to be avoided.
 */
/*----------------------------------------------------------------------------*/